using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Azure.Cosmos;

namespace Utility.Sql
{
    public sealed class CosmosSqlQueryDefinitionBuilder
    {
        private readonly string tableAlias;
        private readonly bool distinct;
        private readonly bool value;
        private readonly StringBuilder filterClause;
        private readonly Dictionary<string, object> parameters;
        private readonly List<Join> joins;
        private readonly List<FieldName> orderBy;
        private bool logicalOperatorRequired;

        public CosmosSqlQueryDefinitionBuilder(
            string tableAlias,
            bool distinct = false,
            bool value = false)
        {
            this.tableAlias = tableAlias;
            this.distinct = distinct;
            this.value = value;
            this.filterClause = new StringBuilder();
            this.parameters = new Dictionary<string, object>();
            this.joins = new List<Join>();
            this.orderBy = new List<FieldName>();
        }

        public string TableAlias => this.tableAlias;

        public bool Distinct => this.distinct;

        public bool Value => this.value;

        public Dictionary<string, object> Parameters => this.parameters;

        public List<FieldName> OrderBy => this.orderBy;

        public override string ToString()
        {
            var result = new StringBuilder();

            result.Append("SELECT ");

            if (distinct)
            {
                result.Append("DISTINCT ");
            }

            if (value)
            {
                result
                    .Append("VALUE ")
                    .Append(this.tableAlias);
            }
            else
            {
                result.Append("*");
            }

            result
                .Append(" FROM ")
                .Append(this.tableAlias);

            foreach (var join in this.joins)
            {
                result
                    .Append(" JOIN ")
                    .Append(join.Alias)
                    .Append(" IN ")
                    .Append(join.Path);
            }

            if (this.filterClause.Length > 0)
            {
                result
                    .Append(" WHERE ")
                    .Append(this.filterClause.ToString());
            }

            if (this.orderBy.Count > 0)
            {
                result.Append(" ORDER BY ");

                for (var i = 0; i < this.orderBy.Count; ++i)
                {
                    if (i > 0)
                    {
                        result.Append(",");
                    }

                    result.Append(this.orderBy[i].ToString(this.tableAlias));
                }
            }

            return result.ToString();
        }

        public CosmosSqlQueryDefinition Build()
        {
            var queryDefinition = new CosmosSqlQueryDefinition(this.ToString());

            foreach (var parameter in this.parameters)
            {
                queryDefinition.UseParameter(parameter.Key, parameter.Value);
            }

            return queryDefinition;
        }

        // Appends an equality clause against the specified field such that it must equal the provided value.
        public CosmosSqlQueryDefinitionBuilder AppendScalarFieldClause<T>(
            FieldName fieldName,
            T value,
            Func<T, object> parameterSelector)
        {
            if (value == default)
            {
                return this;
            }

            this
                .AppendAndIfNecessary()
                .AppendOpenParenthesis();

            this
                .AppendFieldName(fieldName)
                .Append("=")
                .AppendParameter(parameterSelector(value));

            this.AppendCloseParenthesis();
            return this;
        }

        // Appends an equality clause against the specified field such that it must be one of the provided values.
        public CosmosSqlQueryDefinitionBuilder AppendScalarFieldOneOfClause<T>(
            FieldName fieldName,
            IList<T> values,
            Func<T, object> parameterSelector)
        {
            if (values == null || values.Count == 0)
            {
                return this;
            }

            var count = 0;

            this
                .AppendAndIfNecessary()
                .AppendOpenParenthesis();

            foreach (var value in values)
            {
                this
                    .AppendOrIfNecessary();

                var isDefaultValue = false;

                if (typeof(T).IsEnum)
                {
                    isDefaultValue = Convert.ToInt32(value) == 0;
                }

                if (isDefaultValue)
                {
                    // Default enum values need special treatment because they're not actually written to the JSON.
                    this
                        .Append("NOT is_defined(")
                        .AppendFieldName(fieldName)
                        .Append(")");
                }
                else
                {
                    this
                        .AppendFieldName(fieldName)
                        .Append("=")
                        .AppendParameter(parameterSelector(value));
                }

                ++count;
            }

            this.AppendCloseParenthesis();
            return this;
        }

        // Appends an "array contains" clause for the specified array field such that it must contain the provided values.
        public CosmosSqlQueryDefinitionBuilder AppendArrayFieldClause<T>(
            FieldName fieldName,
            IList<T> values,
            Func<T, object> parameterSelector,
            LogicalOperator logicalOperator = LogicalOperator.Or,
            string subFieldName = null)
        {
            if (values == null || values.Count == 0)
            {
                return this;
            }

            this
                .AppendAndIfNecessary()
                .AppendOpenParenthesis();

            for (var i = 0; i < values.Count; ++i)
            {
                var value = values[i];

                this.AppendLogicalOperatorIfNecessary(logicalOperator);

                this
                    .Append("ARRAY_CONTAINS(")
                    .AppendFieldName(fieldName)
                    .Append(",");

                if (subFieldName == null)
                {
                    this
                        .AppendParameter(parameterSelector(value))
                        .Append(")");
                }
                else
                {
                    this
                        .Append("{\"")
                        .Append(subFieldName)
                        .Append("\":")
                        .AppendParameter(parameterSelector(value))
                        .Append("},true)");
                }
            }

            this.AppendCloseParenthesis();
            return this;
        }

        // Appends a bounding-box constraint on the specified lat/long fields.
        public CosmosSqlQueryDefinitionBuilder AppendBoundingBoxClause(
            FieldName longitudeFieldName,
            FieldName latitudeFieldName,
            double? northWestLatitude,
            double? northWestLongitude,
            double? southEastLatitude,
            double? southEastLongitude,
            Join requisiteJoin = null)
        {
            if (northWestLatitude == null || northWestLongitude == null || southEastLatitude == null || southEastLongitude == null)
            {
                return this;
            }

            if (requisiteJoin != null)
            {
                this.joins.Add(requisiteJoin);
            }

            this
                .AppendAndIfNecessary()
                .AppendOpenParenthesis();

            // Coordinates for the polygon that surrounds the bounding box
            var boundingBoxCoordinates = new[]
            {
                (longitude: northWestLongitude.Value, latitude: northWestLatitude.Value),
                (longitude: northWestLongitude.Value, latitude: southEastLatitude.Value),
                (longitude: southEastLongitude.Value, latitude: southEastLatitude.Value),
                (longitude: southEastLongitude.Value, latitude: northWestLatitude.Value),
                (longitude: northWestLongitude.Value, latitude: northWestLatitude.Value),
            };

            this
                .Append("ST_WITHIN({'type':'Point','coordinates':[")
                .AppendFieldName(longitudeFieldName)
                .Append(",")
                .AppendFieldName(latitudeFieldName)
                .Append("]},{'type':'Polygon','coordinates':[[");

            for (var i = 0; i < boundingBoxCoordinates.Length; ++i)
            {
                if (i > 0)
                {
                    this.Append(",");
                }

                var current = boundingBoxCoordinates[i];

                this
                    .Append("[")
                    .Append(current.longitude)
                    .Append(",")
                    .Append(current.latitude)
                    .Append("]");
            }

            this
                .Append("]]})")
                .AppendCloseParenthesis();

            return this;
        }

        // Appends a clause that ensures a monetary value is at least the specified amount.
        public CosmosSqlQueryDefinitionBuilder AppendMoneyAtLeastClause(
            FieldName fieldName,
            Money value)
        {
            if (value == Money.Empty)
            {
                return this;
            }

            this
                .AppendAndIfNecessary()
                .AppendOpenParenthesis()
                .AppendFieldName(fieldName + "currencyCode")
                .Append("=")
                .AppendParameter(value.CurrencyCode)
                .AppendAndIfNecessary()
                .AppendOpenParenthesis()
                .AppendOpenParenthesis()
                .AppendFieldName(fieldName + "units")
                .Append("??0")
                .AppendCloseParenthesis()
                .Append(">")
                .AppendParameter(value.Units)
                .AppendOrIfNecessary()
                .AppendOpenParenthesis()
                .AppendOpenParenthesis()
                .AppendFieldName(fieldName + "units")
                .Append("??0")
                .AppendCloseParenthesis()
                .Append("=")
                .AppendParameter(value.Units)
                .AppendAndIfNecessary()
                .AppendOpenParenthesis()
                .AppendFieldName(fieldName + "nanos")
                .Append("??0")
                .AppendCloseParenthesis()
                .Append(">=")
                .AppendParameter(value.NanoUnits)
                .AppendCloseParenthesis()
                .AppendCloseParenthesis()
                .AppendCloseParenthesis();

            return this;
        }

        // Appends a clause that ensures a monetary value is at most the specified amount.
        public CosmosSqlQueryDefinitionBuilder AppendMoneyAtMostClause(
            FieldName fieldName,
            Money value)
        {
            if (value == Money.Empty)
            {
                return this;
            }

            this
                .AppendAndIfNecessary()
                .AppendOpenParenthesis()
                .AppendFieldName(fieldName + "currencyCode")
                .Append("=")
                .AppendParameter(value.CurrencyCode)
                .AppendAndIfNecessary()
                .AppendOpenParenthesis()
                .AppendOpenParenthesis()
                .AppendFieldName(fieldName + "units")
                .Append("??0")
                .AppendCloseParenthesis()
                .Append("<")
                .AppendParameter(value.Units)
                .AppendOrIfNecessary()
                .AppendOpenParenthesis()
                .AppendOpenParenthesis()
                .AppendFieldName(fieldName + "units")
                .Append("??0")
                .AppendCloseParenthesis()
                .Append("=")
                .AppendParameter(value.Units)
                .AppendAndIfNecessary()
                .AppendOpenParenthesis()
                .AppendFieldName(fieldName + "nanos")
                .Append("??0")
                .AppendCloseParenthesis()
                .Append("<=")
                .AppendParameter(value.NanoUnits)
                .AppendCloseParenthesis()
                .AppendCloseParenthesis()
                .AppendCloseParenthesis();

            return this;
        }

        public CosmosSqlQueryDefinitionBuilder AppendFieldName(FieldName fieldName)
        {
            this
                .filterClause
                .Append(fieldName.ToString(this.tableAlias));

            this.logicalOperatorRequired = true;
            return this;
        }

        public CosmosSqlQueryDefinitionBuilder Append(string value)
        {
            this
                .filterClause
                .Append(value);
            this.logicalOperatorRequired = true;

            return this;
        }

        public CosmosSqlQueryDefinitionBuilder AppendOpenParenthesis()
        {
            this.AppendAndIfNecessary();

            this
                .filterClause
                .Append("(");
            this.logicalOperatorRequired = false;

            return this;
        }

        public CosmosSqlQueryDefinitionBuilder AppendCloseParenthesis()
        {
            this
                .filterClause
                .Append(")");
            this.logicalOperatorRequired = true;

            return this;
        }

        public CosmosSqlQueryDefinitionBuilder AppendLogicalOperatorIfNecessary(LogicalOperator logicalOperator)
        {
            if (logicalOperator == LogicalOperator.And)
            {
                return this.AppendAndIfNecessary();
            }
            else
            {
                return this.AppendOrIfNecessary();
            }
        }

        public CosmosSqlQueryDefinitionBuilder AppendOrIfNecessary()
        {
            if (this.logicalOperatorRequired)
            {
                this.Append(" OR ");
                this.logicalOperatorRequired = false;
            }

            return this;
        }

        public CosmosSqlQueryDefinitionBuilder AppendAndIfNecessary()
        {
            if (this.logicalOperatorRequired)
            {
                this.Append(" AND ");
                this.logicalOperatorRequired = false;
            }

            return this;
        }

        private CosmosSqlQueryDefinitionBuilder Append(int value)
        {
            this
                .filterClause
                .Append(value);
            return this;
        }

        private CosmosSqlQueryDefinitionBuilder Append(double value)
        {
            this
                .filterClause
                .Append(value);
            return this;
        }

        private CosmosSqlQueryDefinitionBuilder AppendParameter(object value)
        {
            var parameterName = "@p" + this.parameters.Count;
            this.parameters.Add(parameterName, value);
            return this
                .Append(parameterName);
        }
    }
}

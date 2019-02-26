using System;
using System.Collections.Generic;
using System.Text;

namespace Utility.Sql
{
    public sealed class FilterClauseBuilder
    {
        private readonly string tableAlias;
        private readonly StringBuilder filterClause;
        private readonly Dictionary<string, object> parameters;
        private bool logicalOperatorRequired;

        public FilterClauseBuilder(string tableAlias)
        {
            this.tableAlias = tableAlias;
            this.filterClause = new StringBuilder();
            this.parameters = new Dictionary<string, object>();
        }

        public string TableAlias => this.tableAlias;

        public Dictionary<string, object> Parameters => this.parameters;

        public int Length => this.filterClause.Length;

        public bool IsEmpty => this.Length == 0;

        public override string ToString() =>
            this.filterClause.ToString();

        // Appends an equality clause against the specified field such that it must equal the provided value.
        public FilterClauseBuilder AppendScalarFieldClause<T>(
            string fieldName,
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
                .AppendQualifiedFieldName(fieldName)
                .Append("=")
                .AppendParameter(parameterSelector(value));

            this.AppendCloseParenthesis();
            return this;
        }

        // Appends an equality clause against the specified field such that it must be one of the provided values.
        public FilterClauseBuilder AppendScalarFieldOneOfClause<T>(
            string fieldName,
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
                        .AppendQualifiedFieldName(fieldName)
                        .Append(")");
                }
                else
                {
                    this
                        .AppendQualifiedFieldName(fieldName)
                        .Append("=")
                        .AppendParameter(parameterSelector(value));
                }

                ++count;
            }

            this.AppendCloseParenthesis();
            return this;
        }

        // Appends an "array contains" clause for the specified array field such that it must contain the provided values.
        public FilterClauseBuilder AppendArrayFieldClause<T>(
            string fieldName,
            IList<T> values,
            Func<T, object> parameterSelector,
            FilterLogicalOperator logicalOperator = FilterLogicalOperator.Or,
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
                    .AppendQualifiedFieldName(fieldName)
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
        public FilterClauseBuilder AppendBoundingBoxClause(string longitudeFieldName, string latitudeFieldName, double? northWestLatitude, double? northWestLongitude, double? southEastLatitude, double? southEastLongitude)
        {
            if (northWestLatitude == null || northWestLongitude == null || southEastLatitude == null || southEastLongitude == null)
            {
                return this;
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
                .AppendQualifiedFieldName(longitudeFieldName)
                .Append(",")
                .AppendQualifiedFieldName(latitudeFieldName)
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
        public FilterClauseBuilder AppendMoneyAtLeastClause(
            string fieldName,
            Money value)
        {
            if (value == Money.Empty)
            {
                return this;
            }

            this
                .AppendAndIfNecessary()
                .AppendOpenParenthesis()
                .AppendQualifiedFieldName(fieldName + ".currencyCode")
                .Append("=")
                .AppendParameter(value.CurrencyCode)
                .AppendAndIfNecessary()
                .AppendOpenParenthesis()
                .AppendOpenParenthesis()
                .AppendQualifiedFieldName(fieldName + ".units")
                .Append("??0")
                .AppendCloseParenthesis()
                .Append(">")
                .AppendParameter(value.Units)
                .AppendOrIfNecessary()
                .AppendOpenParenthesis()
                .AppendOpenParenthesis()
                .AppendQualifiedFieldName(fieldName + ".units")
                .Append("??0")
                .AppendCloseParenthesis()
                .Append("=")
                .AppendParameter(value.Units)
                .AppendAndIfNecessary()
                .AppendOpenParenthesis()
                .AppendQualifiedFieldName(fieldName + ".nanos")
                .Append("??0")
                .AppendCloseParenthesis()
                .Append(">=")
                .AppendParameter(value.NanoUnits)
                .AppendCloseParenthesis()
                .AppendCloseParenthesis()
                .AppendCloseParenthesis();

            return this;
        }

        public FilterClauseBuilder AppendQualifiedFieldName(string fieldName)
        {
            this
                .filterClause
                .Append(this.tableAlias)
                .Append(".")
                .Append(fieldName);
            this.logicalOperatorRequired = true;

            return this;
        }

        public FilterClauseBuilder Append(string value)
        {
            this
                .filterClause
                .Append(value);
            this.logicalOperatorRequired = true;

            return this;
        }

        public FilterClauseBuilder AppendOpenParenthesis()
        {
            this.AppendAndIfNecessary();

            this
                .filterClause
                .Append("(");
            this.logicalOperatorRequired = false;

            return this;
        }

        public FilterClauseBuilder AppendCloseParenthesis()
        {
            this
                .filterClause
                .Append(")");
            this.logicalOperatorRequired = true;

            return this;
        }

        private FilterClauseBuilder Append(int value)
        {
            this
                .filterClause
                .Append(value);
            return this;
        }

        private FilterClauseBuilder Append(double value)
        {
            this
                .filterClause
                .Append(value);
            return this;
        }

        private FilterClauseBuilder AppendLogicalOperatorIfNecessary(FilterLogicalOperator logicalOperator)
        {
            if (logicalOperator == FilterLogicalOperator.And)
            {
                return this.AppendAndIfNecessary();
            }
            else
            {
                return this.AppendOrIfNecessary();
            }
        }

        private FilterClauseBuilder AppendOrIfNecessary()
        {
            if (this.logicalOperatorRequired)
            {
                this.Append(" OR ");
                this.logicalOperatorRequired = false;
            }

            return this;
        }

        private FilterClauseBuilder AppendAndIfNecessary()
        {
            if (this.logicalOperatorRequired)
            {
                this.Append(" AND ");
                this.logicalOperatorRequired = false;
            }

            return this;
        }

        private FilterClauseBuilder AppendParameter(object value)
        {
            var parameterName = "@p" + this.parameters.Count;
            this.parameters.Add(parameterName, value);
            return this
                .Append(parameterName);
        }
    }
}

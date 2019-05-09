using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using AutoFixture;
using AutoFixture.Kernel;
using Genesis.Ensure;

namespace IntegrationTests.AutoFixture
{
    // Populate get-only collections, such as Protobuf repeated fields
    internal sealed class GetOnlyCollectionsCustomization : ICustomization
    {
        public void Customize(IFixture fixture)
        {
            fixture.Customizations.Add(
                new FilteringSpecimenBuilder(
                    new Postprocessor(
                        new MethodInvoker(
                            new ModestConstructorQuery()),
                            new GetOnlyCollectionsCustomizationFiller()),
                    new GetOnlyCollectionsSpecification()));
        }

        private sealed class GetOnlyCollectionsCustomizationFiller : ISpecimenCommand
        {
            public void Execute(object specimen, ISpecimenContext context)
            {
                Ensure.ArgumentNotNull(specimen, nameof(specimen));
                Ensure.ArgumentNotNull(context, nameof(context));

                var allProperties = specimen
                    .GetType()
                    .GetProperties(BindingFlags.Public | BindingFlags.Instance | BindingFlags.GetProperty)
                    .ToList();

                var getOnlyCollectionProperties = allProperties
                    .Where(property => !property.CanWrite)
                    .Where(property => property.PropertyType.IsGenericType && property.PropertyType.GenericTypeArguments.Length == 1)
                    .Where(property => typeof(IList).IsAssignableFrom(property.PropertyType))
                    .ToList();

                var nonCollectionProperties = allProperties
                    .Where(property => property.CanWrite)
                    .Except(getOnlyCollectionProperties)
                    .ToList();

                foreach (var getOnlyCollectionProperty in getOnlyCollectionProperties)
                {
                    var list = (IList)getOnlyCollectionProperty.GetValue(specimen);

                    if (list == null)
                    {
                        continue;
                    }

                    var enumerableType = typeof(IEnumerable<>).MakeGenericType(getOnlyCollectionProperty.PropertyType.GenericTypeArguments[0]);
                    var items = (IEnumerable)context.Resolve(enumerableType);

                    foreach (var item in items)
                    {
                        list.Add(item);
                    }
                }

                // Fill in the remaining properties.
                foreach (var nonCollectionProperty in nonCollectionProperties)
                {
                    var value = context.Resolve(nonCollectionProperty.PropertyType);
                    nonCollectionProperty.SetValue(specimen, value);
                }
            }
        }

        private sealed class GetOnlyCollectionsSpecification : IRequestSpecification
        {
            public bool IsSatisfiedBy(object request)
            {
                var requestType = request as Type;

                if (requestType == null)
                {
                    return false;
                }

                var getOnlyCollectionProperties = requestType
                    .GetProperties(BindingFlags.Public | BindingFlags.Instance | BindingFlags.GetProperty)
                    .Where(property => !property.CanWrite)
                    .Where(property => property.PropertyType.IsGenericType && property.PropertyType.GenericTypeArguments.Length == 1)
                    .Where(property => typeof(IList).IsAssignableFrom(property.PropertyType))
                    .ToList();

                return getOnlyCollectionProperties.Count > 0;
            }
        }
    }
}

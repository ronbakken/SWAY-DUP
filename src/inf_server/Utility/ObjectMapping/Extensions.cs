using Google.Protobuf.Collections;

namespace AutoMapper
{
    public static class Extensions
    {
        public static void MapRepeatedFields(this IMapperConfigurationExpression @this)
        {
            // See https://stackoverflow.com/a/46412302/1228288
            bool IsToRepeatedField(PropertyMap propertyMap)
            {
                if (propertyMap.DestinationType.IsConstructedGenericType)
                {
                    var destinationTypeGenericBase = propertyMap.DestinationType.GetGenericTypeDefinition();
                    return destinationTypeGenericBase == typeof(RepeatedField<>);
                }

                return false;
            }
            @this.ForAllPropertyMaps(IsToRepeatedField, (propertyMap, options) => options.UseDestinationValue());
        }
    }
}

using System;
using Mapping.Interfaces;
using api = global::API.Interfaces.MapItemDto.Types;

namespace API.Services.Mapping
{
    public static class MapItemStatusExtensions
    {
        public static api.MapItemStatus ToDto(this MapItemStatus @this)
        {
            switch (@this)
            {
                case MapItemStatus.Active:
                    return api.MapItemStatus.Active;
                case MapItemStatus.Inactive:
                    return api.MapItemStatus.Inactive;
                default:
                    throw new NotSupportedException();
            }
        }

        public static MapItemStatus ToServiceObject(this api.MapItemStatus @this)
        {
            switch (@this)
            {
                case api.MapItemStatus.Active:
                    return MapItemStatus.Active;
                case api.MapItemStatus.Inactive:
                    return MapItemStatus.Inactive;
                default:
                    throw new NotSupportedException();
            }
        }
    }
}

using System;
using Mapping.Interfaces;
using static API.Interfaces.SearchRequest.Types;

namespace API.Services.Mapping
{
    public static class MapItemTypeExtensions
    {
        public static MapItemTypes ToServiceObject(this MapItemType @this)
        {
            switch (@this)
            {
                case MapItemType.Offer:
                    return MapItemTypes.Offers;
                case MapItemType.User:
                    return MapItemTypes.Users;
                default:
                    throw new NotSupportedException();
            }
        }
    }
}

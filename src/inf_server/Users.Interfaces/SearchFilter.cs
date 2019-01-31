﻿using System.Collections.Generic;
using System.Runtime.Serialization;

namespace Users.Interfaces
{
    [DataContract]
    public sealed class SearchFilter
    {
        public SearchFilter(
            UserTypes userTypes,
            List<int> categoryIds,
            List<int> socialMediaNetworkIds,
            SearchLocation location,
            int? minimumValue,
            string phrase)
        {
            this.UserTypes = userTypes;
            this.CategoryIds = categoryIds;
            this.SocialMediaNetworkIds = socialMediaNetworkIds;
            this.Location = location;
            this.MinimumValue = minimumValue;
            this.Phrase = phrase;
        }

        [DataMember]
        public UserTypes UserTypes { get; private set; }

        [DataMember]
        public List<int> CategoryIds { get; private set; }

        [DataMember]
        public List<int> SocialMediaNetworkIds { get; private set; }

        [DataMember]
        public SearchLocation Location { get; private set; }

        [DataMember]
        public int? MinimumValue { get; private set; }

        [DataMember]
        public string Phrase { get; private set; }
    }
}

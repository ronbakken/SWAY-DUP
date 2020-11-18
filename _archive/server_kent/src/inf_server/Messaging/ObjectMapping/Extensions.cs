using System.Linq;
using Messaging.Interfaces;

namespace Messaging.ObjectMapping
{
    public static class Extensions
    {
        public static Conversation ToServiceDto(this ConversationEntity @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new Conversation
            {
                Id = @this.Id,
                UserId = @this.PartitionKey,
                Status = @this.Status.ToServiceObject(),
                TopicId = @this.TopicId,
                LatestMessage = @this.LatestMessage.ToServiceObject(),
                LatestMessageWithAction = @this.LatestMessageWithAction.ToServiceObject(),
            };
            result.Metadata.Add(@this.Metadata);

            return result;
        }

        public static MessageEntity ToEntity(this Message @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new MessageEntity
            {
                Id = @this.Id,
                PartitionKey = @this.ConversationId,
                Action = @this.Action,
                Text = @this.Text,
                User = @this.User.ToEntity(),
                Created = @this.Timestamp,
            };

            result.Attachments.AddRange(@this.Attachments.Select(x => x.ToEntity()));

            return result;
        }

        public static Message ToServiceObject(this MessageEntity @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new Message
            {
                Action = @this.Action,
                Id = @this.Id,
                ConversationId = @this.PartitionKey,
                Text = @this.Text,
                Timestamp = @this.Created,
                User = @this.User.ToServiceObject(),
            };

            result.Attachments.AddRange(@this.Attachments.Select(x => x.ToServiceObject()));

            return result;
        }

        public static MessageAttachmentEntity ToEntity(this MessageAttachment @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new MessageAttachmentEntity
            {
                ContentType = @this.ContentType,
                Data = @this.Data,
            };

            result.Metadata.Add(@this.Metadata);

            return result;
        }

        public static MessageAttachment ToServiceObject(this MessageAttachmentEntity @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new MessageAttachment
            {
                ContentType = @this.ContentType,
                Data = @this.Data,
            };

            result.Metadata.Add(@this.Metadata);

            return result;
        }

        public static UserEntity ToEntity(this User @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new UserEntity
            {
                Id = @this.Id,
                Name = @this.Name,
                Revision = @this.Revision,
                Status = @this.Status.ToEntity(),
                AvatarThumbnail = @this.AvatarThumbnail.ToEntity(),
            };

            return result;
        }

        public static User ToServiceObject(this UserEntity @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new User
            {
                Id = @this.Id,
                Name = @this.Name,
                Revision = @this.Revision,
                Status = @this.Status.ToServiceObject(),
                AvatarThumbnail = @this.AvatarThumbnail.ToServiceObject(),
            };

            return result;
        }

        public static ImageEntity ToEntity(this Image @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new ImageEntity
            {
                Url = @this.Url,
                LowResUrl = @this.LowResUrl,
            };

            return result;
        }

        public static Image ToServiceObject(this ImageEntity @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new Image
            {
                Url = @this.Url,
                LowResUrl = @this.LowResUrl,
            };

            return result;
        }

        public static ConversationEntity.Types.Status ToEntity(this Conversation.Types.Status @this) =>
            (ConversationEntity.Types.Status)(int)@this;

        public static Conversation.Types.Status ToServiceObject(this ConversationEntity.Types.Status @this) =>
            (Conversation.Types.Status)(int)@this;

        public static UserEntity.Types.Status ToEntity(this User.Types.Status @this) =>
            (UserEntity.Types.Status)(int)@this;

        public static User.Types.Status ToServiceObject(this UserEntity.Types.Status @this) =>
            (User.Types.Status)(int)@this;
    }
}

using System.Linq;
using API.Interfaces;
using Users.Interfaces;
using messaging = Messaging.Interfaces;

namespace API.ObjectMapping
{
    public static class MessagingExtensions
    {
        public static MessageDto ToMessageDto(this messaging.Message @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new MessageDto
            {
                Id = @this.Id,
                Action = @this.Action,
                Text = @this.Text,
                Timestamp = @this.Timestamp,
                User = @this.User.ToUserDto(),
            };

            result.Attachments.AddRange(@this.Attachments.Select(x => x.ToMessageAttachmentDto()));

            return result;
        }

        public static messaging.Message ToMessage(this MessageDto @this, User user)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new messaging.Message
            {
                Id = @this.Id,
                Action = @this.Action,
                Text = @this.Text,
                Timestamp = @this.Timestamp,
                User = user.ToMessagingUser(),
            };

            result.Attachments.AddRange(@this.Attachments.Select(x => x.ToMessageAttachment()));

            return result;
        }

        public static MessageAttachmentDto ToMessageAttachmentDto(this messaging.MessageAttachment @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new MessageAttachmentDto
            {
                ContentType = @this.ContentType,
                Data = @this.Data,
            };

            result.Metadata.Add(@this.Metadata);

            return result;
        }

        public static messaging.MessageAttachment ToMessageAttachment(this MessageAttachmentDto @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new messaging.MessageAttachment
            {
                ContentType = @this.ContentType,
                Data = @this.Data,
            };

            result.Metadata.Add(@this.Metadata);

            return result;
        }

        public static UserDto ToUserDto(this messaging.User @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new UserDto
            {
                Id = @this.Id,
                Revision = @this.Revision,
                Status = @this.Status.ToStatus(),
                Handle = new UserDto.Types.HandleDataDto
                {
                    Name = @this.Name,
                    AvatarThumbnail = @this.AvatarThumbnail.ToImageDto(),
                },
            };

            return result;
        }

        public static ImageDto ToImageDto(this messaging.Image @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new ImageDto
            {
                Url = @this.Url,
                LowResUrl = @this.LowResUrl,
            };

            return result;
        }

        public static messaging.User ToMessagingUser(this User @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new messaging.User
            {
                Id = @this.Id,
                Revision = @this.Revision,
                Status = @this.Status.ToMessagingStatus(),
                Name = @this.Name,
                AvatarThumbnail = @this.AvatarThumbnail.ToServiceObject(),
            };

            return result;
        }

        public static messaging.Image ToServiceObject(this global::Users.Interfaces.Image @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new messaging.Image
            {
                Url = @this.Url,
                LowResUrl = @this.LowResUrl,
            };

            return result;
        }

        public static ConversationDto ToConversationDto(this messaging.Conversation @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new ConversationDto
            {
                Id = @this.Id,
                Status = @this.Status.ToStatus(),
                TopicId = @this.TopicId,
                LatestMessage = @this.LatestMessage.ToMessageDto(),
                LatestMessageWithAction = @this.LatestMessageWithAction.ToMessageDto(),
            };

            result.Metadata.Add(@this.Metadata);

            return result;
        }

        public static messaging.Conversation.Types.Status ToConversationStatus(this ConversationDto.Types.Status @this) =>
            (messaging.Conversation.Types.Status)(int)@this;

        public static messaging.User.Types.Status ToMessagingStatus(this UserStatus @this) =>
            (messaging.User.Types.Status)(int)@this;

        public static UserDto.Types.Status ToStatus(this messaging.User.Types.Status @this) =>
            (UserDto.Types.Status)(int)@this;

        public static messaging.User.Types.Status ToStatus(this UserDto.Types.Status @this) =>
            (messaging.User.Types.Status)(int)@this;

        public static ConversationDto.Types.Status ToStatus(this messaging.Conversation.Types.Status @this) =>
            (ConversationDto.Types.Status)(int)@this;
    }
}

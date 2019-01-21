using Genesis.TestUtil;
using Moq;
using User.Interfaces;

namespace API.Services.Auth
{
    public sealed class UserActorFactoryBuilder : IBuilder
    {
        private readonly Mock<IUserActorFactory> userActorFactory;

        public UserActorFactoryBuilder()
        {
            this.userActorFactory = new Mock<IUserActorFactory>();
        }

        public UserActorFactoryBuilder WithUser(IUser user)
        {
            this
                .userActorFactory
                .Setup(x => x.Get(It.IsAny<string>()))
                .Returns(user);
            return this;
        }


        public IUserActorFactory Build() =>
            this.userActorFactory.Object;
    }

    public sealed class UserMockBuilder : IBuilder
    {
        private readonly Mock<IUser> user;

        public UserMockBuilder()
        {
            this.user = new Mock<IUser>();
            this
                .user
                .Setup(x => x.GetData())
                .ReturnsAsync(UserData.Initial);
        }

        public Mock<IUser> Build() =>
            this.user;

        public static implicit operator Mock<IUser>(UserMockBuilder builder) =>
            builder.Build();
    }

    public sealed class EmailServiceMockBuilder : IBuilder
    {
        private readonly Mock<IEmailService> emailService;

        public EmailServiceMockBuilder()
        {
            this.emailService = new Mock<IEmailService>();
        }

        public Mock<IEmailService> Build() =>
            this.emailService;

        public static implicit operator Mock<IEmailService>(EmailServiceMockBuilder builder) =>
            builder.Build();
    }
}

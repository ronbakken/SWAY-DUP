using Genesis.TestUtil;
using Moq;
using Users.Interfaces;

namespace API.Services.Auth
{
    public sealed class UsersServiceMockBuilder : IBuilder
    {
        private readonly Mock<IUsersService> usersService;

        public UsersServiceMockBuilder()
        {
            this.usersService = new Mock<IUsersService>();
            this
                .usersService
                .Setup(x => x.GetUserData(It.IsAny<string>()))
                .ReturnsAsync(UserData.Initial);
        }

        public Mock<IUsersService> Build() =>
            this.usersService;

        public static implicit operator Mock<IUsersService>(UsersServiceMockBuilder builder) =>
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

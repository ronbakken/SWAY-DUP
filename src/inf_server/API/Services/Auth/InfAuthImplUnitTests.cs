using System.Threading.Tasks;
using API.Interfaces;
using Moq;
using User.Interfaces;
using Xunit;

namespace API.Services.Auth
{
    public sealed class InfAuthImplUnitTests
    {
        [Fact]
        public async Task send_login_email_updates_user_data_appropriately()
        {
            var sut = new InfAuthImpl();
            var request = new SendLoginEmailRequest
            {
                Email = "kent.boogaart@gmail.com",
            };
            var userMock = new UserMockBuilder()
                .Build();
            UserData capturedUserData = null;
            userMock
                .Setup(x => x.SetData(It.IsAny<UserData>()))
                .Callback<UserData>((userData) => capturedUserData = userData)
                .Returns(Task.CompletedTask);
            var userActorFactory = new UserActorFactoryBuilder()
                .WithUser(userMock.Object)
                .Build();
            var emailService = new EmailServiceMockBuilder()
                .Build();

            await sut.SendLoginEmailImpl(
                request,
                userActorFactory,
                emailService.Object,
                default);

            Assert.NotNull(capturedUserData.LoginToken);
            Assert.NotEmpty(capturedUserData.LoginToken);
            Assert.Equal(UserStatus.WaitingForActivation, capturedUserData.Status);
        }
    }
}

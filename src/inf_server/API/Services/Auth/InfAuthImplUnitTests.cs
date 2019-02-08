using System.Threading.Tasks;
using API.Interfaces;
using Moq;
using Users.Interfaces;
using Xunit;

namespace API.Services.Auth
{
    public sealed class InfAuthImplUnitTests
    {
        //[Fact]
        //public async Task send_login_email_updates_user_data_appropriately()
        //{
        //    var sut = new InfAuthImpl();
        //    var request = new SendLoginEmailRequest
        //    {
        //        Email = "kent.boogaart@gmail.com",
        //    };
        //    var usersService = new UsersServiceMockBuilder()
        //        .Build();
        //    UserData capturedUserData = null;
        //    usersService
        //        .Setup(x => x.SaveUserData(It.IsAny<string>(), It.IsAny<UserData>()))
        //        .Callback<string, UserData>((userId, userData) => capturedUserData = userData)
        //        .Returns(() => Task.FromResult(capturedUserData));
        //    var emailService = new EmailServiceMockBuilder()
        //        .Build();

        //    await sut.SendLoginEmailImpl(
        //        request,
        //        usersService.Object,
        //        emailService.Object,
        //        default).ContinueOnAnyContext();

        //    Assert.NotNull(capturedUserData.LoginToken);
        //    Assert.NotEmpty(capturedUserData.LoginToken);
        //    Assert.Equal(UserStatus.WaitingForActivation, capturedUserData.Status);
        //}
    }
}

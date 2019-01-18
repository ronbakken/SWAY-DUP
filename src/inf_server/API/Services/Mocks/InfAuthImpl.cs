using System;
using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;
using static API.Interfaces.InfAuth;
using interfaces = API.Interfaces;

namespace API.Services.Mocks
{
    class InfAuthImpl : InfAuthBase
    {
        public override Task<RefreshTokenMessage> CreateNewUser(CreateNewUserRequest request, ServerCallContext context)
        {
            return base.CreateNewUser(request, context);
        }

        // Not sure if we will need this
        public override Task<interfaces.User> GetCurrentUser(RefreshTokenMessage request, ServerCallContext context)
        {
            return base.GetCurrentUser(request, context);
        }

        public override Task<SocialMediaAccounts> GetSocialMediaAccountsForUser(SocialMediaRequest request, ServerCallContext context)
        {
            Console.WriteLine("InfConfigImpl.GetSocialMediaAccountsForUser called");

            var response = new SocialMediaAccounts();

            var socialMediaAccounts = DatabaseMock.Instance().GetSocialMediaAccounts(request.UserId);
            if (socialMediaAccounts != null)
            {
                response.Accounts.Add(socialMediaAccounts);
            }

            return Task.FromResult(response);
        }

        public override Task<LoginResultMessage> Login(RefreshTokenMessage request, ServerCallContext context)
        {
            Console.WriteLine("InfConfigImpl.Login called");

            var user = DatabaseMock.Instance().GetUser(request.RefreshToken);
            if (user != null)
            {
                return Task.FromResult(new LoginResultMessage { AuthorizationToken = "4711", UserData = user });
            }
            else
            {
                return Task.FromResult(new LoginResultMessage());
            }
        }

        public override Task<RefreshTokenMessage> RequestRefreshToken(RefreshTokenRequest request, ServerCallContext context)
        {
            Console.WriteLine("InfConfigImpl.RequestRefreshToken called");
            return Task.FromResult(new RefreshTokenMessage());
        }

        public override Task<Empty> SendLoginEmail(LoginEmailRequest request, ServerCallContext context)
        {
            Console.WriteLine("InfConfigImpl.SendLoginEmail called");
            return Task.FromResult(new Empty());
        }

        public override Task<InvitationCodeState> ValidateInvitationCode(interfaces.InvitationCode request, ServerCallContext context)
        {
            Console.WriteLine("InfConfigImpl.ValidateInvitationCode called");

            if (request.Code != "invalid")
            {
                return Task.FromResult(new InvitationCodeState { State = InvitationCodeStates.Valid });
            }
            else
            {
                return Task.FromResult(new InvitationCodeState { State = InvitationCodeStates.Invalid });
            }
        }
    }
}

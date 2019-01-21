using System;
using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;

namespace API.Services.Mocks
{
    class InfAuthImpl : InfAuth.InfAuthBase
    {

        public override Task<CreateNewUserResponse> CreateNewUser(CreateNewUserRequest request, ServerCallContext context)
        {
            Console.WriteLine("InfConfigImpl.CreateNewUser called");
            return base.CreateNewUser(request, context);
        }

        public override Task<GetAccessTokenResponse> GetAccessToken(GetAccessTokenRequest request, ServerCallContext context)
        {
            Console.WriteLine("InfConfigImpl.GetAccessToken called");
            return base.GetAccessToken(request, context);
        }

        // Not sure if we will need this
        public override Task<GetUserResponse> GetUser(GetUserRequest request, ServerCallContext context)
        {
            Console.WriteLine("InfConfigImpl.GetUser called");
            return base.GetUser(request, context);
        }


        public override Task<LoginWithLoginTokenResponse> LoginWithLoginToken(LoginWithLoginTokenRequest request, ServerCallContext context)
        {
            Console.WriteLine("InfConfigImpl.Login called");

            var user = DatabaseMock.Instance().GetUser(request.LoginToken);
            if (user != null)
            {
                return Task.FromResult(new LoginWithLoginTokenResponse { RefreshToken = "4711", UserData = user });
            }
            else
            {
                return Task.FromResult(new LoginWithLoginTokenResponse());
            }
        }

        public override Task<LoginWithRefreshTokenResponse> LoginWithRefreshToken(LoginWithRefreshTokenRequest request, ServerCallContext context)
        {
            Console.WriteLine("InfConfigImpl.LoginWithRefreshToken called");
            var user = DatabaseMock.Instance().GetUser(request.RefreshToken);
            if (user != null)
            {
                return Task.FromResult(new LoginWithRefreshTokenResponse { AccessToken = "4711", UserData = user });
            }
            else
            {
                return Task.FromResult(new LoginWithRefreshTokenResponse());
            }
        }

        public override Task<Empty> SendLoginEmail(SendLoginEmailRequest request, ServerCallContext context)
        {
            Console.WriteLine("InfConfigImpl.SendLoginEmail called");
            return Task.FromResult(new Empty());
        }

        public override Task<Empty> UpdateUser(UpdateUserRequest request, ServerCallContext context)
        {
            Console.WriteLine("InfConfigImpl.UpdateUser called");
            return base.UpdateUser(request, context);
        }
    }
}

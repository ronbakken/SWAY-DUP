﻿using System;
using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;

namespace MockServer
{
    class InfAuthImpl : InfAuth.InfAuthBase
    {

        public override Task<ActivateUserResponse> ActivateUser(ActivateUserRequest request, ServerCallContext context)
        {
            Console.WriteLine("InfConfigImpl.CreateNewUser called");
            var result = new ActivateUserResponse
            {
                User = request.User,
            };
            return Task.FromResult(result);
        }

        public override Task<GetAccessTokenResponse> GetAccessToken(GetAccessTokenRequest request, ServerCallContext context)
        {
            Console.WriteLine("InfConfigImpl.GetAccessToken called");
            var response = new GetAccessTokenResponse
            {
                AccessToken = "at328947127893461287",
            };

            return Task.FromResult(response);
        }



        public override Task<LoginWithLoginTokenResponse> LoginWithLoginToken(LoginWithLoginTokenRequest request, ServerCallContext context)
        {
            Console.WriteLine("InfConfigImpl.LoginWithLoginToken called");

            var user = DatabaseMock.Instance().GetUser(request.LoginToken);
            if (user != null)
            {
                return Task.FromResult(new LoginWithLoginTokenResponse { RefreshToken = "4711", User = user });
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
                return Task.FromResult(new LoginWithRefreshTokenResponse { AccessToken = "4711", User = user });
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



        public override Task<Empty> Logout(LogoutRequest request, ServerCallContext context)
        {
            Console.WriteLine("InfConfigImpl.Logout called");
            return Task.FromResult(new Empty());
        }
    }
}

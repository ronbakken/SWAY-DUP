using System;
using System.Fabric;
using System.Linq;
using System.Threading.Tasks;
using API.Interfaces;
using API.Services.Auth;
using Grpc.Core;
using Microsoft.ServiceFabric.Services.Remoting.Client;
using Serilog;
using Users.Interfaces;
using static API.Interfaces.InfUsers;

namespace API.Services.Users
{
    public sealed class InfUsersImpl : InfUsersBase
    {
        private readonly ILogger logger;

        public InfUsersImpl(ILogger logger)
        {
            this.logger = logger.ForContext<InfUsersImpl>();
        }

        public override Task<GetUserResponse> GetUser(GetUserRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var userId = request.UserId;
                    logger.Debug("Getting data for user {UserId}", userId);
                    var usersService = GetUsersService();
                    var userData = await usersService.GetUserData(userId);
                    logger.Debug("Retrieved data for user {UserId}: {@UserData}", userId, userData);

                    return new GetUserResponse
                    {
                        UserData = userData.ToDto(),
                    };
                });

        public override Task<UpdateUserResponse> UpdateUser(UpdateUserRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var authenticatedUserId = context.GetAuthenticatedUserId();
                    logger.Debug("Validating authenticated user {UserId} matches user ID in request", authenticatedUserId);

                    if (authenticatedUserId != request.User.Email)
                    {
                        logger.Warning("Authenticated user {UserId} does not match user ID in request {RequestUserId} - unable to update user", authenticatedUserId, request.User.Email);
                        throw new RpcException(new Status(StatusCode.PermissionDenied, "Attempted to update data for another user."));
                    }

                    logger.Debug("Getting data for user {UserId}", authenticatedUserId);
                    var usersService = GetUsersService();
                    var userData = await usersService.GetUserData(authenticatedUserId);

                    var updatedUserData = request
                        .User
                        .ToServiceObject(userData.LoginToken);
                    logger.Debug("Saving data for user {UserId}: {@UserData}", authenticatedUserId, updatedUserData);
                    var result = await usersService.SaveUserData(authenticatedUserId, updatedUserData);

                    var response = new UpdateUserResponse
                    {
                        User = result.ToDto(),
                    };

                    return response;
                });

        public override Task<SearchUsersResponse> SearchUsers(SearchUsersRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var results = await SearchUsersImpl(
                        logger,
                        request);
                    return results;
                });

        internal async Task<SearchUsersResponse> SearchUsersImpl(ILogger logger, SearchUsersRequest request)
        {
            var searchFilter = request.ToServiceObject();
            var usersService = GetUsersService();

            logger.Debug("Searching for users using filter {@SearchFilter}", searchFilter);
            var results = await usersService.Search(searchFilter);

            var response = new SearchUsersResponse();
            response.Results.AddRange(results.Select(result => result.ToDto()));

            return response;
        }

        private static IUsersService GetUsersService() =>
            ServiceProxy.Create<IUsersService>(new Uri($"{FabricRuntime.GetActivationContext().ApplicationName}/Users"));
    }
}

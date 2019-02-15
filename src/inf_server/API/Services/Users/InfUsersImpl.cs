using System.Linq;
using System.Threading.Tasks;
using API.Interfaces;
using AutoMapper;
using Grpc.Core;
using Serilog;
using Users.Interfaces;
using Utility;
using static API.Interfaces.InfUsers;
using static Users.Interfaces.UsersService;

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
                    var usersService = await GetUsersServiceClient().ContinueOnAnyContext();
                    var getUserDataResponse = await usersService
                        .GetUserDataAsync(new GetUserDataRequest { Id = userId });
                    var userData = getUserDataResponse.UserData;
                    logger.Debug("Retrieved data for user {UserId}: {@UserData}", userId, userData);

                    return new GetUserResponse
                    {
                        UserData = Mapper.Map<UserDto>(userData),
                    };
                });

        public override Task<UpdateUserResponse> UpdateUser(UpdateUserRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var authenticatedUserId = context.GetAuthenticatedUserId();
                    logger.Debug("Validating authenticated user {UserId} matches user ID in request", authenticatedUserId);

                    if (authenticatedUserId != request.User.Id.ValueOr(null))
                    {
                        logger.Warning("Authenticated user {UserId} does not match user ID in request {RequestUserId} - unable to update user", authenticatedUserId, request.User.Email);
                        throw new RpcException(new Status(StatusCode.PermissionDenied, "Attempted to update data for another user."));
                    }

                    logger.Debug("Getting data for user {UserId}", authenticatedUserId);
                    var usersService = await GetUsersServiceClient().ContinueOnAnyContext();
                    var getUserDataResponse = await usersService
                        .GetUserDataAsync(new GetUserDataRequest { Id = authenticatedUserId });
                    var userData = getUserDataResponse.UserData;

                    var updatedUserData = Mapper.Map<UserData>(request.User);
                    logger.Debug("Saving data for user {UserId}: {@UserData}", authenticatedUserId, updatedUserData);
                    var saveUserDataResponse = await usersService
                        .SaveUserDataAsync(new SaveUserDataRequest { UserData = updatedUserData });
                    userData = saveUserDataResponse.UserData;

                    var response = new UpdateUserResponse
                    {
                        User = Mapper.Map<UserDto>(userData),
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
                            request)
                        .ContinueOnAnyContext();
                    return results;
                });

        internal async Task<SearchUsersResponse> SearchUsersImpl(ILogger logger, SearchUsersRequest request)
        {
            var searchFilter = Mapper.Map<SearchFilter>(request);
            var usersService = await GetUsersServiceClient().ContinueOnAnyContext();

            logger.Debug("Searching for users using filter {@SearchFilter}", searchFilter);
            var searchResponse = await usersService
                .SearchAsync(new global::Users.Interfaces.SearchRequest { Filter = searchFilter });
            var results = searchResponse.Results;

            var response = new SearchUsersResponse();
            response.Results.AddRange(results.Select(result => Mapper.Map<UserDto>(result)));

            return response;
        }

        private static Task<UsersServiceClient> GetUsersServiceClient() =>
            APIClientResolver.Resolve<UsersServiceClient>("Users");
    }
}

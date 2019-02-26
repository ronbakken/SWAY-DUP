using System.Threading.Tasks;
using API.Interfaces;
using API.ObjectMapping;
using Grpc.Core;
using Serilog;
using Users.Interfaces;
using Utility;
using static API.Interfaces.InfUsers;
using static Users.Interfaces.UsersService;
using api = API.Interfaces;
using service = Users.Interfaces;

namespace API.Services.Users
{
    public sealed class InfUsersImpl : InfUsersBase
    {
        private readonly ILogger logger;

        public InfUsersImpl(ILogger logger)
        {
            this.logger = logger.ForContext<InfUsersImpl>();
        }

        public override Task<api.GetUserResponse> GetUser(api.GetUserRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var userId = request.UserId;
                    logger.Debug("Getting user {UserId}", userId);
                    var usersService = await GetUsersServiceClient().ContinueOnAnyContext();
                    var getUserResponse = await usersService
                        .GetUserAsync(new service.GetUserRequest { Id = userId });
                    var user = getUserResponse.User;
                    logger.Debug("Retrieved user {UserId}: {@User}", userId, user);

                    return new api.GetUserResponse
                    {
                        User = user.ToUserDto(UserDto.DataOneofCase.Full),
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
                        logger.Warning("Authenticated user {UserId} does not match user ID in request {RequestUserId} - unable to update user", authenticatedUserId, request.User.Id);
                        throw new RpcException(new Status(StatusCode.PermissionDenied, "Attempted to update another user."));
                    }

                    logger.Debug("Getting user {UserId}", authenticatedUserId);
                    var usersService = await GetUsersServiceClient().ContinueOnAnyContext();
                    var getUserResponse = await usersService
                        .GetUserAsync(new service.GetUserRequest { Id = authenticatedUserId });
                    var user = getUserResponse.User;

                    var updatedUser = request.User.ToUser();
                    logger.Debug("Saving user {UserId}: {@User}", authenticatedUserId, updatedUser);
                    var saveUserResponse = await usersService
                        .SaveUserAsync(new SaveUserRequest { User = updatedUser });
                    user = saveUserResponse.User;

                    var response = new UpdateUserResponse
                    {
                        User = user.ToUserDto(UserDto.DataOneofCase.Full),
                    };

                    return response;
                });

        private static Task<UsersServiceClient> GetUsersServiceClient() =>
            APIClientResolver.Resolve<UsersServiceClient>("Users");
    }
}

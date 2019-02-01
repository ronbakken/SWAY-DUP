using System;
using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;


namespace MockServer
{
    class InfUsersImpl : InfUsers.InfUsersBase
    {
        public override Task<GetUserResponse> GetUser(GetUserRequest request, ServerCallContext context)
        {
            Console.WriteLine("InfConfigImpl.GetUser called");
            var user = DatabaseMock.Instance().GetUser("INF");
            var response = new GetUserResponse
            {
                UserData = user,
            };
            return Task.FromResult(response);

        }

        public override Task<SearchUsersResponse> SearchUsers(SearchUsersRequest request, ServerCallContext context)
        {
            return base.SearchUsers(request, context);
        }

        public override Task<UpdateUserResponse> UpdateUser(UpdateUserRequest request, ServerCallContext context)
        {
            Console.WriteLine("InfConfigImpl.UpdateUser called");

            DatabaseMock.Instance().UpdateUser(request.User);
            return Task.FromResult(new UpdateUserResponse { User = request.User });
        }
    }
}

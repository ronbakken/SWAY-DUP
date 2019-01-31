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

        public override Task<SearchResponse> Search(SearchRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var results = await SearchImpl(
                        logger,
                        request);
                    return results;
                });

        internal async Task<SearchResponse> SearchImpl(ILogger logger, SearchRequest request)
        {
            var searchFilter = request.ToServiceObject();
            var usersService = GetUsersService();

            logger.Debug("Searching for users using filter {@SearchFilter}", searchFilter);
            var results = await usersService.Search(searchFilter);

            var response = new SearchResponse();
            response.Results.AddRange(results.Select(result => result.ToDto()));

            return response;
        }

        private static IUsersService GetUsersService() =>
            ServiceProxy.Create<IUsersService>(new Uri($"{FabricRuntime.GetActivationContext().ApplicationName}/Users"));
    }
}

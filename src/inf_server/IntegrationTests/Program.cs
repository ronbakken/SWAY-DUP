using System;
using System.IO;
using System.Threading.Tasks;
using AutoFixture;
using Grpc.Core;
using IntegrationTests.AutoFixture;
using IntegrationTests.Tests;
using Microsoft.Azure.Cosmos;
using Serilog;

namespace IntegrationTests
{
    class Program
    {
        private const string logFileName = "integration-tests.log";

        public static async Task<int> Main(string[] args)
        {
            if (File.Exists(logFileName))
            {
                File.Delete(logFileName);
            }

            var rootLogger = new LoggerConfiguration()
                .Enrich.WithProcessId()
                .Enrich.WithProcessName()
                .Enrich.WithThreadId()
                .Enrich.WithMemoryUsage()
                .Enrich.FromLogContext()
                .MinimumLevel.Debug()
                .WriteTo.Debug()
                .WriteTo.File(logFileName)
                .CreateLogger();

            using (rootLogger)
            {
                if (args.Length != 2)
                {
                    rootLogger.Error("Incorrect number of process arguments.");
                    return -1;
                }

                var serverAddress = args[0];
                var databaseConnectionString = args[1];
                var logger = rootLogger
                    .ForContext("ServerAddress", serverAddress)
                    .ForContext("DatabaseConnectionString", databaseConnectionString);

                logger.Information("Server address is {ServerAddress}, database connection string is {DatabaseConnectionString}", serverAddress, databaseConnectionString);

                var fixture = new Fixture()
                    .Customize(new GetOnlyCollectionsCustomization());

                var channel = new Channel(serverAddress, ChannelCredentials.Insecure);
                var executionContext = new ExecutionContext(logger, fixture)
                    .WithServerAddress(serverAddress)
                    .WithServerChannel(channel)
                    .WithDatabaseConnectionString(databaseConnectionString)
                    .WithDatabaseClient(new CosmosClient(databaseConnectionString));

                var executionPlan = ExecutionPlan
                    .Default
                    // System
                    .AddTest(new Test(nameof(Tests.System.Ping), Tests.System.Ping))
                    // Config
                    .AddTest(new Test(nameof(Config.GetVersions), Config.GetVersions))
                    .AddTest(new Test(nameof(Config.GetAppConfig), Config.GetAppConfig))
                    .AddTest(new Test(nameof(Config.GetWelcomeImages), Config.GetWelcomeImages))
                    // Auth
                    .AddTest(new Test(nameof(Auth.LoginNewInfluencer), Auth.LoginNewInfluencer))
                    .AddTest(new Test(nameof(Auth.LoginNewBusiness), Auth.LoginNewBusiness))
                    .AddTest(new Test(nameof(Auth.ActivateInfluencer), Auth.ActivateInfluencer))
                    .AddTest(new Test(nameof(Auth.ActivateBusiness), Auth.ActivateBusiness))
                    .AddTest(new Test(nameof(Auth.LoginExistingInfluencer), Auth.LoginExistingInfluencer))
                    .AddTest(new Test(nameof(Auth.LoginExistingBusiness), Auth.LoginExistingBusiness))
                    // Users
                    .AddTest(new Test(nameof(Users.UpdateInfluencer), Users.UpdateInfluencer))
                    .AddTest(new Test(nameof(Users.UpdateBusiness), Users.UpdateBusiness))
                    // Offers
                    .AddTest(new Test(nameof(Offers.UpdateOffer), Offers.UpdateOffer))
                    // BlobStorage
                    .AddTest(new Test(nameof(BlobStorage.Upload), BlobStorage.Upload))
                    // List
                    .AddTest(new Test(nameof(List.ListUsersAsAnInfluencer), List.ListUsersAsAnInfluencer))
                    .AddTest(new Test(nameof(List.ListUsersAsABusiness), List.ListUsersAsABusiness))
                    .AddTest(new Test(nameof(List.ListOffers), List.ListOffers))
                    // Listen
                    .AddTest(new Test(nameof(Listen.ListenForSingleUser), Listen.ListenForSingleUser))
                    .AddTest(new Test(nameof(Listen.ListenForOffers), Listen.ListenForOffers))
                    // Auth
                    .AddTest(new Test(nameof(Auth.LogoutInfluencer), Auth.LogoutInfluencer))
                    .AddTest(new Test(nameof(Auth.LogoutBusiness), Auth.LogoutBusiness));

                try
                {
                    await executionPlan.Execute(logger, executionContext);

                    logger.Information("Done");
                    return 0;
                }
                catch (Exception ex)
                {
                    logger.Error(ex, "Execution failed");
                    return -1;
                }
            }
        }
    }
}

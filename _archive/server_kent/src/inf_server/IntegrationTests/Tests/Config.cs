using System;
using System.Threading;
using System.Threading.Tasks;
using API.Interfaces;
using Xunit;

namespace IntegrationTests.Tests
{
    public static class Config
    {
        public static async Task<ExecutionContext> GetAppConfig(ExecutionContext context)
        {
            var client = new InfConfig.InfConfigClient(context.GetServerChannel());
            var config = await client.GetAppConfigAsync(Empty.Instance);

            Assert.NotNull(config.AppConfigData);
            Assert.NotEmpty(config.AppConfigData.Categories);
            Assert.NotEmpty(config.AppConfigData.DeliverableIcons);
            Assert.NotEmpty(config.AppConfigData.SocialNetworkProviders);
            Assert.NotEmpty(config.AppConfigData.PrivacyPolicyUrl);
            Assert.NotEmpty(config.AppConfigData.TermsOfServiceUrl);

            return context;
        }

        public static async Task<ExecutionContext> GetVersions(ExecutionContext context)
        {
            var client = new InfConfig.InfConfigClient(context.GetServerChannel());
            var versions = await client.GetVersionsAsync(Empty.Instance);

            Assert.NotNull(versions.VersionInfo);

            return context;
        }

        public static async Task<ExecutionContext> GetWelcomeImages(ExecutionContext context)
        {
            var client = new InfConfig.InfConfigClient(context.GetServerChannel());
            var welcomeImagesCall = client.GetWelcomeImages(Empty.Instance);
            var cts = new CancellationTokenSource();
            cts.CancelAfter(TimeSpan.FromSeconds(10));

            GetWelcomeImagesResponse response = null;

            if (await welcomeImagesCall.ResponseStream.MoveNext(cts.Token))
            {
                response = welcomeImagesCall.ResponseStream.Current;
            }

            Assert.NotNull(response);
            Assert.NotEmpty(response.ImageUrls);

            return context;
        }
    }
}

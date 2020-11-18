using System;
using System.Threading.Tasks;
using API.Interfaces;

namespace IntegrationTests.Tests
{
    public static class System
    {
        public static async Task<ExecutionContext> Ping(ExecutionContext context)
        {
            var logger = context.Logger;

            // We accommodate retries because sometimes the just-deployed cluster doesn't respond straight away.
            var retryCount = 0;

            while (true)
            {
                try
                {
                    var client = new InfSystem.InfSystemClient(context.GetServerChannel());
                    await client.PingServerAsync(Empty.Instance);
                    break;
                }
                catch (Exception ex)
                {
                    logger.Error(ex, "Ping failed");
                    ++retryCount;

                    if (retryCount == 3)
                    {
                        throw;
                    }
                }

                var sleepSeconds = 10 * retryCount;
                logger.Debug("Ping failed, so sleeping for {Seconds} seconds", sleepSeconds);
                await Task.Delay(TimeSpan.FromSeconds(sleepSeconds));
            }

            return context;
        }
    }
}

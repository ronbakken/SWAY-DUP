﻿using System;
using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;

namespace MockServer
{
    class Program
    {
        const int port = 8080;

        public static async Task Main(string[] args)
        {
            var server = new Server
            {
                Services =
                {
                    InvitationCodes.BindService(new InvitationCodesImpl()),
                    InfApi.BindService(new InfApiImpl()),
                    InfAuth.BindService(new InfAuthImpl()),
                    InfConfig.BindService(new InfConfigImpl()),
                    InfSystem.BindService(new InfSystemImpl()),
                },
                Ports =
                {
                    new ServerPort("0.0.0.0", port, ServerCredentials.Insecure)
                },
            };
            server.Start();

            Console.WriteLine($"Mock INF server is now listening on port {port}.");
            Console.WriteLine("Press any key to stop the server...");
            Console.ReadKey();

            await server.ShutdownAsync();
        }
    }
}

﻿using System;
using System.Diagnostics;
using System.Threading;
using Microsoft.ServiceFabric.Services.Runtime;
using Newtonsoft.Json;
using Utility.Serialization;

namespace InvitationCodes
{
    internal static class Program
    {
        /// <summary>
        /// This is the entry point of the service host process.
        /// </summary>
        private static void Main()
        {
            try
            {
                // The ServiceManifest.XML file defines one or more service type names.
                // Registering a service maps a service type name to a .NET type.
                // When Service Fabric creates an instance of this service type,
                // an instance of the class is created in this host process.

                ServiceRuntime.RegisterServiceAsync("InvitationCodesType",
                    context => new InvitationCodes(context)).GetAwaiter().GetResult();

                ServiceEventSource.Instance.ServiceTypeRegistered(Process.GetCurrentProcess().Id, typeof(InvitationCodes).Name);

                // Prevents this host process from terminating so services keep running.
                Thread.Sleep(Timeout.Infinite);
            }
            catch (Exception e)
            {
                ServiceEventSource.Instance.ServiceHostInitializationFailed(e.ToString());
                throw;
            }
        }
    }
}

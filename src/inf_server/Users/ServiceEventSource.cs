using System;
using System.Diagnostics.Tracing;
using System.Fabric;
using Utility.Diagnostics;

namespace Users
{
    [EventSource(Name = "INF-server-Users")]
    internal sealed class ServiceEventSource : EventSource, IFailureEventSource
    {
        public static readonly ServiceEventSource Instance = new ServiceEventSource();

        private ServiceEventSource() : base()
        {
        }

        private const int VerboseEventId = 1;
        private const int InfoEventId = 2;
        private const int WarnEventId = 3;
        private const int ErrorEventId = 4;
        private const int CriticalEventId = 5;
        private const int ServiceMessageEventId = 6;
        private const int ServiceTypeRegisteredEventId = 7;
        private const int ServiceHostInitializationFailedEventId = 8;
        private const int ServiceRequestStartEventId = 9;
        private const int ServiceRequestStopEventId = 10;
        private const int FailureEventId = 11;

        public static class Keywords
        {
            public const EventKeywords Requests = (EventKeywords)0x1L;
            public const EventKeywords ServiceInitialization = (EventKeywords)0x2L;
        }

        [NonEvent]
        public void Verbose(string message, params object[] args)
        {
            if (this.IsEnabled())
            {
                var formattedMessage = string.Format(message, args);
                Verbose(formattedMessage);
            }
        }

        [Event(VerboseEventId, Level = EventLevel.Verbose, Message = "{0}")]
        public void Verbose(string message)
        {
            if (this.IsEnabled())
            {
                WriteEvent(VerboseEventId, message);
            }
        }

        [NonEvent]
        public void Info(string message, params object[] args)
        {
            if (this.IsEnabled())
            {
                var formattedMessage = string.Format(message, args);
                Info(formattedMessage);
            }
        }

        [Event(InfoEventId, Level = EventLevel.Informational, Message = "{0}")]
        public void Info(string message)
        {
            if (this.IsEnabled())
            {
                WriteEvent(InfoEventId, message);
            }
        }

        [NonEvent]
        public void Warn(string message, params object[] args)
        {
            if (this.IsEnabled())
            {
                var formattedMessage = string.Format(message, args);
                Warn(formattedMessage);
            }
        }

        [Event(WarnEventId, Level = EventLevel.Warning, Message = "{0}")]
        public void Warn(string message)
        {
            if (this.IsEnabled())
            {
                WriteEvent(WarnEventId, message);
            }
        }

        [NonEvent]
        public void Error(string message, params object[] args)
        {
            if (this.IsEnabled())
            {
                var formattedMessage = string.Format(message, args);
                Error(formattedMessage);
            }
        }

        [Event(ErrorEventId, Level = EventLevel.Error, Message = "{0}")]
        public void Error(string message)
        {
            if (this.IsEnabled())
            {
                WriteEvent(ErrorEventId, message);
            }
        }

        [NonEvent]
        public void Critical(string message, params object[] args)
        {
            if (this.IsEnabled())
            {
                var formattedMessage = string.Format(message, args);
                Critical(formattedMessage);
            }
        }

        [Event(CriticalEventId, Level = EventLevel.Critical, Message = "{0}")]
        public void ErrorCritical(string message)
        {
            if (this.IsEnabled())
            {
                WriteEvent(CriticalEventId, message);
            }
        }

        [NonEvent]
        public void ServiceMessage(StatelessServiceContext serviceContext, string message, params object[] args)
        {
            if (this.IsEnabled())
            {
                var formattedMessage = string.Format(message, args);
                ServiceMessage(
                    serviceContext.ServiceName.ToString(),
                    serviceContext.ServiceTypeName,
                    serviceContext.InstanceId,
                    serviceContext.PartitionId,
                    serviceContext.CodePackageActivationContext.ApplicationName,
                    serviceContext.CodePackageActivationContext.ApplicationTypeName,
                    serviceContext.NodeContext.NodeName,
                    formattedMessage);
            }
        }

        [Event(ServiceMessageEventId, Level = EventLevel.Informational, Message = "{7}")]
        private void ServiceMessage(
            string serviceName,
            string serviceTypeName,
            long replicaOrInstanceId,
            Guid partitionId,
            string applicationName,
            string applicationTypeName,
            string nodeName,
            string message) =>
            WriteEvent(ServiceMessageEventId, serviceName, serviceTypeName, replicaOrInstanceId, partitionId, applicationName, applicationTypeName, nodeName, message);

        [Event(ServiceTypeRegisteredEventId, Level = EventLevel.Informational, Message = "Service host process {0} registered service type {1}", Keywords = Keywords.ServiceInitialization)]
        public void ServiceTypeRegistered(int hostProcessId, string serviceType) =>
            WriteEvent(ServiceTypeRegisteredEventId, hostProcessId, serviceType);

        [Event(ServiceHostInitializationFailedEventId, Level = EventLevel.Error, Message = "Service host initialization failed", Keywords = Keywords.ServiceInitialization)]
        public void ServiceHostInitializationFailed(string exception) =>
            WriteEvent(ServiceHostInitializationFailedEventId, exception);

        [Event(ServiceRequestStartEventId, Level = EventLevel.Informational, Message = "Service request '{0}' started", Keywords = Keywords.Requests)]
        public void ServiceRequestStart(string requestTypeName) =>
            WriteEvent(ServiceRequestStartEventId, requestTypeName);

        [Event(ServiceRequestStopEventId, Level = EventLevel.Informational, Message = "Service request '{0}' finished", Keywords = Keywords.Requests)]
        public void ServiceRequestStop(string requestTypeName, string exception = "") =>
            WriteEvent(ServiceRequestStopEventId, requestTypeName, exception);

        [NonEvent]
        public void Failure(Exception exception, string message)
        {
            if (this.IsEnabled())
            {
                Failure(message, exception?.ToString());
            }
        }

        [NonEvent]
        public void Failure(Exception exception, string message, params object[] args)
        {
            if (this.IsEnabled())
            {
                var formattedMessage = string.Format(message, args);
                Failure(formattedMessage, exception?.ToString());
            }
        }

        [Event(FailureEventId, Level = EventLevel.Critical, Message = "{0}")]
        private void Failure(string message, string exception)
        {
            if (this.IsEnabled())
            {
                WriteEvent(FailureEventId, message, exception);
            }
        }
    }
}

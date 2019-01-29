using System;

namespace Microsoft.ServiceFabric.Services.Runtime
{
    public interface IFailureEventSource
    {
        void Failure(string message, Exception exception);
    }
}

using System;

namespace Utility.Diagnostics
{
    /// <summary>
    /// Allows event sources to provide a means of logging failures.
    /// </summary>
    public interface IFailureEventSource
    {
        void Failure(Exception exception, string message);

        void Failure(Exception exception, string message, params object[] args);
    }
}

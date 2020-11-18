﻿using System;
using System.Collections.Immutable;
using System.Threading;
using Serilog.Context;

namespace Utility
{
    // Based on https://github.com/serilog/serilog/issues/1015#issuecomment-379085955.
    public static class LoggingContextCorrelator
    {
        private static readonly AsyncLocal<ImmutableDictionary<string, object>> _items = new AsyncLocal<ImmutableDictionary<string, object>>();

        private static ImmutableDictionary<string, object> Items
        {
            get => _items.Value ?? (_items.Value = ImmutableDictionary<string, object>.Empty);
            set => _items.Value = value;
        }

        public static object GetValue(string key) => Items[key];

        public static bool TryGetValue(string key, out object value) =>
            Items.TryGetValue(key, out value);

        public static IDisposable BeginCorrelationScope(string key, object value)
        {
            if (Items.ContainsKey(key))
            {
                throw new InvalidOperationException($"{key} is already being correlated!");
            }

            var scope = new CorrelationScope(Items, LogContext.PushProperty(key, value));
            Items = Items.Add(key, value);
            return scope;
        }

        public static IDisposable BeginOrReplaceCorrelationScope(string key, object value)
        {
            var scope = new CorrelationScope(Items, LogContext.PushProperty(key, value));
            Items = Items.Remove(key).Add(key, value);
            return scope;
        }

        private sealed class CorrelationScope : IDisposable
        {
            private readonly ImmutableDictionary<string, object> _bookmark;
            private readonly IDisposable _logContextPop;

            public CorrelationScope(ImmutableDictionary<string, object> bookmark, IDisposable logContextPop)
            {
                _bookmark = bookmark ?? throw new ArgumentNullException(nameof(bookmark));
                _logContextPop = logContextPop ?? throw new ArgumentNullException(nameof(logContextPop));
            }

            public void Dispose()
            {
                _logContextPop.Dispose();
                Items = _bookmark;
            }
        }
    }
}

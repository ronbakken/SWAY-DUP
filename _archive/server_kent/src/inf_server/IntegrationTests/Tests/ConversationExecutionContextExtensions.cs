namespace IntegrationTests.Tests
{
    // Adds conversation related information/abilities to execution context.
    public static class ConversationExecutionContextExtensions
    {
        private const string conversationIdKey = "ConversationId";

        public static ExecutionContext WithConversationId(this ExecutionContext @this, string conversationId) =>
            @this.WithDataValue(conversationIdKey, conversationId);

        public static ExecutionContext WithoutConversationId(this ExecutionContext @this) =>
            @this.WithoutDataValue(conversationIdKey);

        public static string GetConversationId(this ExecutionContext @this) =>
            (string)@this.Data[conversationIdKey];
    }
}

function setConversationParticipantListening(data) {
    var context = getContext();
    var response = context.getResponse();
    var container = context.getCollection();

    var conversationId = data.conversationId;
    var userId = data.userId;
    var isListening = data.isListening;

    if (!conversationId) {
        throw new Error("conversationId not set.");
    }

    if (!userId) {
        throw new Error("userId not set.");
    }

    if (!isListening) {
        throw new Error("isListening not set.");
    }

    var now = new Date();

    console.log("Setting conversation participant listening with conversation ID '" + conversationId + "', user ID '" + userId + "', is listening " + isListening + ". It is now " + now);

    var existingQuery =
    {
        "query": "SELECT * FROM d WHERE d.schemaType = @SchemaType AND d.id = @UserId",
        "parameters": [
            { "name": "@SchemaType", "value": "conversationParticipant" },
            { "name": "@UserId", "value": userId }
        ]
    };

    var queryAccepted = container.queryDocuments(
        container.getSelfLink(),
        existingQuery,
        {},
        function (err, items, responseOptions) {
            if (err) {
                throw new Error("Error querying documents: " + err.message);
            }

            if (items.length === 0) {
                console.log("Conversation participant not found");
                throw new Error("Conversation participant not found");
            }

            var conversationParticipant = items[0];
            conversationParticipant.isListening = isListening;

            var upsertDocumentAccepted = container.upsertDocument(
                container.getSelfLink(),
                conversationParticipant,
                function (err, _) {
                    if (err) {
                        throw new Error("Error upserting conversation participant: " + err.message);
                    }

                    response.setBody("OK");
                });

            if (!upsertDocumentAccepted) {
                throw new Error("Upsert document not accepted.");
            }
        });

    if (!queryAccepted) {
        throw new Error("Query not accepted.");
    }
}
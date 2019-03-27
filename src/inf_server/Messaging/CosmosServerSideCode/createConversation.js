function createConversation(data) {
    var context = getContext();
    var response = context.getResponse();
    var container = context.getCollection();

    var id = data.id;
    var topicId = data.topicId;
    var userId = data.userId;
    var firstMessage = data.firstMessage;

    if (!id) {
        throw new Error("ID not set.");
    }

    if (!topicId) {
        throw new Error("Topic ID not set.");
    }

    if (!userId) {
        throw new Error("User ID not set.");
    }

    if (!firstMessage) {
        throw new Error("First message not set.");
    }

    var now = new Date();

    console.log("Creating conversation with ID '" + id + "', topic ID '" + topicId + "', user ID '" + userId + "'. It is now " + now);

    var existingQuery =
    {
        "query": "SELECT * FROM d WHERE d.schemaType = @SchemaType AND d.topicId = @TopicId",
        "parameters": [
            { "name": "@SchemaType", "value": "conversation" },
            { "name": "@TopicId", "value": topicId }
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

            if (items.length > 0) {
                console.log("A conversation about topic '" + topicId + "' already exists");
                throw new Error("A conversation about topic '" + topicId + "' already exists");
            }

            var conversation = {
                schemaType: "conversation",
                schemaVersion: 1,
                partitionKey: userId,
                id: id,
                status: "open",
                topicId: topicId,
                latestMessage: firstMessage
            };

            var upsertDocumentAccepted = container.upsertDocument(
                container.getSelfLink(),
                conversation,
                function (err, _) {
                    if (err) {
                        throw new Error("Error upserting conversation: " + err.message);
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
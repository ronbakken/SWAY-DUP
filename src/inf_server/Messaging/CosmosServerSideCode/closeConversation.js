function closeConversation(data) {
    var context = getContext();
    var response = context.getResponse();
    var container = context.getCollection();

    var id = data.id;
    var userId = data.userId;

    if (!id) {
        throw new Error("id not set.");
    }

    if (!userId) {
        throw new Error("userId not set.");
    }

    var now = new Date();

    console.log("Closing conversation with ID '" + id + "', user ID '" + userId + "'. It is now " + now);

    var existingQuery =
    {
        "query": "SELECT * FROM d WHERE d.schemaType = @SchemaType AND d.id = @Id",
        "parameters": [
            { "name": "@SchemaType", "value": "conversation" },
            { "name": "@Id", "value": id }
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

            if (items.length !== 1) {
                console.log("Conversation not found");
                throw new Error("The conversation was not found.");
            }

            var conversation = items[0];

            if (conversation.status !== "open") {
                console.log("Conversation has status '" + conversation.status + "'");
                throw new Error("The conversation is not open.");
            }

            conversation.status = "closed";

            var upsertDocumentAccepted = container.upsertDocument(
                container.getSelfLink(),
                conversation,
                function (err, _) {
                    if (err) {
                        throw new Error("Error upserting conversation: " + err.message);
                    }

                    response.setBody(conversation);
                });

            if (!upsertDocumentAccepted) {
                throw new Error("Upsert document not accepted.");
            }
        });

    if (!queryAccepted) {
        throw new Error("Query not accepted.");
    }
}
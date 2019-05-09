function createConversation(data) {
    var context = getContext();
    var response = context.getResponse();
    var container = context.getCollection();

    var id = data.id;
    var topicId = data.topicId;
    var userId = data.userId;
    var firstMessage = data.firstMessage;
    var metadata = data.metadata;

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

    var conversation = {
        schemaType: "conversation",
        schemaVersion: 1,
        partitionKey: userId,
        id: id,
        status: "open",
        topicId: topicId,
        latestMessage: firstMessage,
        latestMessageWithAction: firstMessage.action ? firstMessage : null,
        metadata: metadata
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
}
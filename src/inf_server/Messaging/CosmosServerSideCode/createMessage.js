function createMessage(data) {
    var context = getContext();
    var response = context.getResponse();
    var container = context.getCollection();

    var conversationId = data.conversationId;
    var message = data.message;

    if (!conversationId) {
        throw new Error("conversationId not set.");
    }

    if (!message) {
        throw new Error("message not set.");
    }

    var now = new Date();

    message.schemaType = "message";
    message.schemaVersion = 1;
    message.partitionKey = conversationId;
    message.created = now;

    console.log("Creating message against conversation ID '" + conversationId + "' for user with ID '" + message.user.id + "'. It is now " + now);

    var upsertDocumentAccepted = container.upsertDocument(
        container.getSelfLink(),
        message,
        function (err, _) {
            if (err) {
                throw new Error("Error upserting message: " + err.message);
            }

            response.setBody(message);
        });

    if (!upsertDocumentAccepted) {
        throw new Error("Upsert document not accepted.");
    }
}
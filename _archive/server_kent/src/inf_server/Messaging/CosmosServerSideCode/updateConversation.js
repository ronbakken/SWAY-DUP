function updateConversation(data) {
    var context = getContext();
    var response = context.getResponse();
    var container = context.getCollection();
    var containerLink = container.getSelfLink();

    var id = data.id;
    var latestMessage = data.latestMessage;
    var latestMessageWithAction = data.latestMessageWithAction;

    if (!id) {
        throw new Error("ID not set.");
    }

    if (!latestMessage) {
        throw new Error("Latest message not set.");
    }

    var now = new Date();

    console.log("Updating conversation with ID '" + id + "'. It is now " + now);

    tryQueryAndUpdate();

    function tryQueryAndUpdate() {
        var query = {
            query: "SELECT * FROM c WHERE c.schemaType=@schemaType AND c.id=@id",
            parameters:
                [
                    {
                        name: "@schemaType",
                        value: "conversation"
                    },
                    {
                        name: "@id",
                        value: id
                    }
                ]
        };

        var isAccepted = container.queryDocuments(containerLink, query, {}, function (err, documents, responseOptions) {
            if (err) throw err;

            if (documents.length === 1) {
                tryUpdate(documents[0]);
            } else {
                throw new Error("Document not found.");
            }
        });

        if (!isAccepted) {
            throw new Error("The stored procedure timed out.");
        }
    }

    function tryUpdate(document) {
        document.latestMessage = latestMessage;

        if (latestMessageWithAction) {
            document.latestMessageWithAction = latestMessageWithAction;
        }

        var isAccepted = container.replaceDocument(
            document._self,
            document,
            {},
            function (err, updatedDocument, responseOptions) {
                if (err) throw err;

                response.setBody(updatedDocument);
            });

        if (!isAccepted) {
            throw new Error("The stored procedure timed out.");
        }
    }
}
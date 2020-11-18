function saveUser(user) {
    var context = getContext();
    var response = context.getResponse();
    var container = context.getCollection();

    var id = user.id;

    if (!id) {
        throw new Error("ID not set.");
    }

    var now = new Date();

    console.log("Saving user with ID '" + id + "'. It is now " + now);

    var existingQuery =
    {
        "query": "SELECT * FROM Users u WHERE u.id = @Id",
        "parameters": [
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

            var existingUser;

            if (items.length === 1) {
                console.log("User with ID '" + id + "' already exists");
                existingUser = items[0];

                user.created = existingUser.created;

                var existingRevision = existingUser.revision;
                var proposedRevision = user.revision;

                if (existingRevision !== proposedRevision) {
                    throw new Error("Proposed revision " + proposedRevision + " does not equal current revision of " + existingRevision);
                }

                user.revision = existingRevision + 1;

                var existingStatus = existingUser.status;
                var proposedStatus = user.status;

                if (existingStatus !== proposedStatus) {
                    console.log("Status has changed from " + existingStatus + " to " + proposedStatus + " - updating status timestamp");
                    user.statusTimestamp = now.toISOString();
                } else {
                    user.statusTimestamp = existingUser.statusTimestamp;
                }
            } else {
                console.log("User with ID '" + id + "' does not yet exist");

                user.revision = 1;
                user.created = now.toISOString();
            }

            var upsertDocumentAccepted = container.upsertDocument(
                container.getSelfLink(),
                user,
                function (err, createdUser) {
                    if (err) {
                        throw new Error("Error upserting user: " + err.message);
                    }

                    response.setBody(createdUser);
                });

            if (!upsertDocumentAccepted) {
                throw new Error("Upsert document not accepted.");
            }
        });

    if (!queryAccepted) {
        throw new Error("Query not accepted.");
    }
}
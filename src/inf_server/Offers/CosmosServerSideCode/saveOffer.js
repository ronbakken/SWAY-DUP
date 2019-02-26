function saveOffer(offer) {
    var context = getContext();
    var response = context.getResponse();
    var container = context.getCollection();

    var id = offer.id;
    // TODO: this should change to be a proper user object with ID at some point
    var userId = offer.businessAccountId;

    if (!id) {
        throw new Error("ID not set.");
    }

    if (!userId) {
        throw new Error("UserId not set.");
    }

    var now = new Date();

    console.log("Saving offer with ID '" + id + "', user ID '" + userId + "'. It is now " + now);

    var existingQuery =
    {
        "query": "SELECT * FROM Offers o WHERE o.businessAccountId = @UserId AND o.id = @Id",
        "parameters": [
            { "name": "@UserId", "value": userId },
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

            var existingOffer;

            if (items.length === 1) {
                console.log("Offer with ID '" + id + "' already exists");
                existingOffer = items[0];

                offer.created = existingOffer.created;

                var existingRevision = existingOffer.revision;
                var proposedRevision = offer.revision;

                if (existingRevision !== proposedRevision) {
                    throw new Error("Proposed revision " + proposedRevision + " does not equal current revision of " + existingRevision);
                }

                offer.revision = existingRevision + 1;

                var existingStatus = existingOffer.status;
                var proposedStatus = offer.status;

                if (existingStatus !== proposedStatus) {
                    console.log("Status has changed from " + existingStatus + " to " + proposedStatus + " - updating status timestamp");
                    offer.statusTimestamp = now.toISOString();
                } else {
                    offer.statusTimestamp = existingOffer.statusTimestamp;
                }
            } else {
                console.log("Offer with ID '" + id + "' does not yet exist");

                offer.revision = 1;
                offer.created = now.toISOString();
            }

            var upsertDocumentAccepted = container.upsertDocument(
                container.getSelfLink(),
                offer,
                function (err, createdOffer) {
                    if (err) {
                        throw new Error("Error upserting offer: " + err.message);
                    }

                    response.setBody(createdOffer);
                });

            if (!upsertDocumentAccepted) {
                throw new Error("Upsert document not accepted.");
            }
        });

    if (!queryAccepted) {
        throw new Error("Query not accepted.");
    }
}
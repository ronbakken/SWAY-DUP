# INF Server

This contains the services that make up the INF server.

Currently there is one majestic monolith service. Preconfigured to connect stand-alone with development databases. Just run it.

## Todo

- Separate social media fetching.
- Put profile information into Elasticsearch instead of SQL. (That is, user profile details, not account data.)
- Separate where necessary.
- Hash slot sharding approach for chat routing (sharded redis pubsub or custom).
- Map cache (custom or any cache that supports sorted queries).

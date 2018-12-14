# INF Server

This contains the microservices that make up the INF server.

Currently there is one microservice. Preconfigured to connect stand-alone with development databases. Just run it.

## Todo

- Put profile information into Elasticsearch instead of SQL. (That is, user profile details, not account data.)
- Separate where necessary.
- Hash slot sharding approach for chat routing (sharded redis pubsub or custom).
- Map cache (custom or any cache that supports sorted queries).

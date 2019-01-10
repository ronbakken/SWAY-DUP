# INF Server

This contains the services that make up the INF server.

Currently there is one majestic monolith service. Preconfigured to connect stand-alone with development databases. Just run it.

## Service Ports

List of service ports is provided here to ensure we don't have overlapping ports anywhere. This allows us to easily set up on a development machine.

| Service | Port |
| --- | --- |
| API gRPC | 8900 |
| Push API gRPC | 8910 |
| Push API WS | 8911 |
| Push Backend | 8919 |
| JWT Backend HTTP | 8928 |
| JWT Backend gRPC | 8929 |
| Elasticsearch API | 9200 |
| Elasticsearch Mesh | 9300 |
| MariaDB | 3306 |
| phpMyAdmin | 8096 |
| Account MariaDB | 3307 |
| Account phpMyAdmin | 8097 |
| Proposal MariaDB | 3308 |
| Proposal phpMyAdmin | 8098 |
| Kibana | 5601 |
| Envoy Proxy HTTP | 80 |
| Envoy Proxy HTTPS | 443 |
| Envoy Proxy HTTP Localhost | 8080 |
| Envoy Proxy HTTP Localhost Admin | 8082 |
| Envoy Proxy HTTPS Localhost | 8443 |

## Sample Service Ports

| Sample | Service | Port |
| --- | --- | --- |
| JWT | Dart gRPC | 7900 |
| JWT | Envoy Proxy | 7901 |
| JWT | Envoy Proxy Admin | 7902 |

## Todo

- Use gRPC.
- Separate social media fetching.
- Put profile information into Elasticsearch instead of SQL. (That is, user profile details, not account data.)
- Separate where necessary.
- Hash slot sharding approach for chat routing (sharded redis pubsub or custom).
- Map cache (custom or any cache that supports sorted queries).

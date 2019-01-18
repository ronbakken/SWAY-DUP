## Project Structure

* **inf_api_client**: The client package that gets included with the app
* **inf_server**: The VS Solution for the server code


## Generating gRPC Code for Dart

1. Install protoc for Dart according to [this documentation](https://grpc.io/docs/quickstart/dart.html).
2. Execute `generate_proto.bat`.


## Generating gRPC Code for C#

1. Install the `Grpc.Tools` NuGet package as a tool:

    ```
    <PackageReference Include="Grpc.Tools" PrivateAssets="true" />
    ```
2. Add `.proto` files to the project. As long as they're included as `ProtoBuf` items, code will be automatically generated:
    ```
    <ItemGroup>
        <ProtoBuf Include="*.proto" />
    </ItemGroup>
    ```


## Including Dart Client Package

To include the Dart client package into the app project, add the following to the `pubspec.yml`:

```
inf_api_client:
  git:
    url: https://github.com/infmarketplace/inf_server.git
    path: src/inf_api_client
```
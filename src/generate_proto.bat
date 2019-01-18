@echo off
echo Generating...
protoc.exe ^
    --plugin=protoc-gen-dart=%APPDATA%\Pub\Cache\bin\protoc-gen-dart.bat ^
    --dart_out=grpc:inf_api_client/lib/src ^
    -Iinf_server/API.Interfaces ^
    category.proto ^
    deliverable.proto ^
    empty.proto ^
    inf_api.proto ^
    inf_auth.proto ^
    inf_config.proto ^
    inf_system.proto ^
    social_media_account.proto ^
    social_network_provider.proto ^
    user.proto
echo ...done
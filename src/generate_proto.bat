@echo off

echo Removing previously generated code...
del /Q /S inf_api_client\lib\src\*

echo Generating...
protoc.exe ^
    --plugin=protoc-gen-dart=%APPDATA%\Pub\Cache\bin\protoc-gen-dart.bat ^
    --dart_out=grpc:inf_api_client/lib/src ^
    -Iinf_server/API.Interfaces ^
    category.proto ^
    deliverable.proto ^
    deal_terms.proto ^
    empty.proto ^
    google/protobuf/timestamp.proto ^
    image.proto ^
    item.proto ^
    item_filter.proto ^
    inf_api.proto ^
    inf_auth.proto ^
    inf_blob_storage.proto ^
    inf_config.proto ^
    inf_invitation_codes.proto ^
    inf_list.proto ^
    inf_listen.proto ^
    inf_messaging.proto ^
    inf_offers.proto ^
    inf_system.proto ^
    inf_users.proto ^
    map_item.proto ^
    money.proto ^
    offer.proto ^
    reward.proto ^
    location.proto ^
    social_media_account.proto ^
    social_network_provider.proto ^
    user.proto
echo ...done

REM FOR /R %%? in (.\inf_server\API.Interfaces\*.proto) DO (
REM     echo Generating code for %%~n?.%%~x?
REM
REM     protoc.exe ^
REM         --plugin=protoc-gen-dart=%APPDATA%\Pub\Cache\bin\protoc-gen-dart.bat ^
REM         --dart_out=grpc:inf_api_client/lib/src ^
REM         -Iinf_server/API.Interfaces ^
REM         %%~n?.%%~x?
REM )

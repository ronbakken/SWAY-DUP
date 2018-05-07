cd ..
git pull
cd protobuf
protoc --dart_out=. inf.proto
protoc --csharp_out=. inf.proto
git add *
cd ../config
cp ../protobuf/*.dart lib/
git add *
cd ..
git commit -m "Update protobuf"
cd config
pub get
dart bin/main.dart
git add *
git commit -m "Update config"
cd ..
git push
git status
cd scripts

cd ../../infclient
git pull
cp ../infserver/protobuf/Inf.cs InfBuildConfig/Inf.cs
cp ../infserver/protobuf/*.dart infapp/lib/
git add *
git commit -m "Update protobuf"
cp ../infserver/config/config.bin infapp/assets/config.bin
git add *
git commit -m "Update config"
git push
git status
cd ../infserver/scripts

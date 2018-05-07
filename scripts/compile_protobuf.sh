cd ..
git pull
cd protobuf
protoc --dart_out=. inf.proto
protoc --csharp_out=. inf.proto
git add *
cd ../config
cp ../infserver/protobuf/*.dart lib/
git add *
cd ..
git commit -m "Update protobuf"
git push
git status
cd scripts

cd ../../infclient
git pull
cp ../infserver/protobuf/Inf.cs InfBuildConfig/Inf.cs
cp ../infserver/protobuf/*.dart infapp/lib/
git add *
git commit -m "Update protobuf"
git push
git status
cd ../infserver/scripts

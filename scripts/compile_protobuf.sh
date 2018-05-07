cd ..
git pull
cd protobuf
protoc --dart_out=. inf.proto
protoc --csharp_out=. inf.proto
git add *
git commit -m "Update protobuf"
git push
git status
cd ..
cd scripts

cd ../../infclient
git pull
cp ../infserver/protobuf/Inf.cs InfBuildConfig/Inf.cs
git add *
git commit -m "Update protobuf"
git push
git status
cd ../infserver/scripts

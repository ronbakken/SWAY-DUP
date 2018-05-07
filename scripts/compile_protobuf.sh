cd ..
git pull
cd protobuf
protoc --dart_out=. inf.proto
git add *
git commit -m "Update protobuf"
git push
git status
cd ..
cd scripts

#!/bin/sh
TOKEN="AIzaSyAFTwtVlRziyFEC1kKWNp4SCfexFuyGqlM"
curl -i https://fcm.googleapis.com/fcm/send \
    -H "Authorization: key=$TOKEN" \
    -H "Content-Type: application/json" \
    -X POST -d @push_test.json

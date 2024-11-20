#!/bin/bash
echo $1
if [ -z "$1" ]; then
    FILE="webhook-commit-status.json"
else
    FILE=$1
fi

curl http://localhost:9292/webhooks \
        -H "Content-Type: application/json" -d @$FILE
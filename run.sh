#!/bin/bash
export PACT_BROKER_SECRETS_ENCRYPTION_KEY=ttDJ1PnVbxGWhIe3T12UHoEfHKB4AvoxdW0JWOg98gE=
cd pact_broker
rm -f pact_broker_database.sqlite3
bundle install
bundle exec rackup -s puma --pid broker.pid &
BROKER_PID=$!
sleep 4
echo "Pact Broker PID: $BROKER_PID"
cd ..
cd webhook_server
bundle install
ruby server.rb &
WEBHOOK_PID=$!
sleep 4
echo "Webhook Server PID: $WEBHOOK_PID"
./create_webhook.sh
curl http://localhost:9292/secrets -d '{"name":"somesecret", "value":"supersecretsquirrel"}' -H "Content-Type: application/json" -X POST
cd ..
cd e2e
bundle install
bundle exec rake pact:spec
cd consumer
bundle exec rake pact:publish
sleep 20
echo "Killing Pact Broker PID: $BROKER_PID"
kill $BROKER_PID
echo "Killing Webhook Server PID: $WEBHOOK_PID"
kill $WEBHOOK_PID
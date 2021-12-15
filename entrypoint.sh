#!/bin/sh

nrEventType=pushEvent

eventJSON=$(jq -n \
               --arg eventType "$nrEventType" \
               --arg user "${NEW_RELIC_DEPLOYMENT_USER}" \
               --arg revision "${NEW_RELIC_DEPLOYMENT_REVISION}" \
               --arg path "${PATH}" \
               '{eventType: $eventType, user: $user, revision: $revision, path: $path}' )

echo $eventJSON

result=$(newrelic events post \
  --event "$eventJSON" \
  2>&1)

exitStatus=$?

if [ $exitStatus -ne 0 ]; then
  echo "::error:: $result"
fi

exit $exitStatus

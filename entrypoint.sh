#!/bin/sh

nrEventType=pushEvent

eventJSON=$(jq -n \
               --arg eventType "$nrEventType" \
               --arg user "${NEW_RELIC_DEPLOYMENT_USER}" \
               --arg repository "${NEW_RELIC_DEPLOYMENT_REPOSITORY}" \
               --arg path "${PATH}" \
               '{eventType: $eventType, user: $user, repository: $repository, path: $path}' )

echo $eventJSON

result=$(newrelic events post \
  --event "$eventJSON" \
  2>&1)

exitStatus=$?

if [ $exitStatus -ne 0 ]; then
  echo "::error:: $result"
fi

exit $exitStatus

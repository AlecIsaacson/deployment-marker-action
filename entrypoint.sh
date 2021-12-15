#!/bin/sh

result=$(newrelic events post \
  --accountId "${NEW_RELIC_ACCOUNT_ID}" \
  --event '{ "eventType": "pushEvent", "user": "${NEW_RELIC_DEPLOYMENT_USER}", "revision": "${NEW_RELIC_DEPLOYMENT_REVISION}" }'
  2>&1)

exitStatus=$?

if [ $exitStatus -ne 0 ]; then
  echo "::error:: $result"
fi

exit $exitStatus

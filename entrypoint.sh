#!/bin/sh

nrEventType=pushEvent

eventJSON=$(jq -n \
               --arg eventType "$nrEventType" \
               --arg user "${NEW_RELIC_DEPLOYMENT_USER}" \
               --arg repository "${GITHUB_REPOSITORY}" \
               --arg githubSHA "${GITHUB_SHA}" \
               --arg repoOwner "${GITHUB_REPOSITORY_OWNER}" \
               '{eventType: $eventType, user: $user, repository: $repository, githubSHA: $githubSHA, repoOwner: $repoOwner}' )

echo $eventJSON

result=$(newrelic events post \
  --event "$eventJSON" \
  2>&1)

exitStatus=$?

if [ $exitStatus -ne 0 ]; then
  echo "::error:: $result"
fi

exit $exitStatus

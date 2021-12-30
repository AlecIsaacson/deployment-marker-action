#!/bin/sh

nrEventType=pushEvent

eventJSON=$(jq -n \
               --arg eventType "$nrEventType" \
               --arg repository "${GITHUB_REPOSITORY}" \
               --arg commitHash "${GITHUB_SHA}" \
               --arg repoOwner "${GITHUB_REPOSITORY_OWNER}" \
               --arg branch "${GITHUB_REF_NAME}" \
               --arg changelog "${NEW_RELIC_DEPLOYMENT_CHANGE_LOG}" \
               --arg description "${NEW_RELIC_DEPLOYMENT_DESCRIPTION}" \
               --arg pushedBy "${NEW_RELIC_PUSH_USER}" \
               --arg pushedEmail "${NEW_RELIC_PUSH_EMAIL}" \
               --arg pushedTimestamp "${NEW_RELIC_PUSH_TIMESTAMP}" \
               --arg repoURL "${NEW_RELIC_REPO_URL}" \
               '{eventType: $eventType, repository: $repository, commitHash: $commitHash, repoOwner: $repoOwner, branch: $branch, description: $description, pushedBy: $pushedBy, pushEmail: $pushedEmail, repoURL: $repoURL, pushedTimestamp: $pushedTimestamp}' )

echo $eventJSON

changes=$(git log --oneline --name-status -1 | tail -n +2 | awk -f /getChanges.awk)

echo $changes

result=$(newrelic events post \
  --event "$eventJSON" \
  2>&1)

exitStatus=$?

if [ $exitStatus -ne 0 ]; then
  echo "::error:: $result"
fi

exit $exitStatus

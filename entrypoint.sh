#!/bin/sh

nrEventType=pushEvent

changes=$(git log --oneline --name-status -1 $NEW_RELIC_PREVIOUS_SHA..$NEW_RELIC_CURRENT_SHA | tail -n +2 | awk -f /getChanges.awk)

count=1
for i in $changes
do
        case $count in
        1)
                export NEW_RELIC_FILES_ADDED=$i
                ;;
        2)
                export NEW_RELIC_FILES_MODIFIED=$i
                ;;
        3)
                export NEW_RELIC_FILES_DELETED=$i
                ;;
        esac
        let "count+=1"
done   

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
               --arg currentSHA "${NEW_RELIC_CURRENT_SHA}" \
               --arg previousSHA "${NEW_RELIC_PREVIOUS_SHA}" \
               --arg filesAdded "${NEW_RELIC_FILES_ADDED}" \
               --arg filesModified "${NEW_RELIC_FILES_MODIFIED}" \
               --arg filesDeleted "${NEW_RELIC_FILES_DELETED}" \
               '{eventType: $eventType, repository: $repository, commitHash: $commitHash, repoOwner: $repoOwner, branch: $branch, description: $description, pushedBy: $pushedBy, pushEmail: $pushedEmail, repoURL: $repoURL, pushedTimestamp: $pushedTimestamp}' )

result=$(newrelic events post \
  --event "$eventJSON" \
  2>&1)

exitStatus=$?

set 

if [ $exitStatus -ne 0 ]; then
  echo "::error:: $result"
fi

exit $exitStatus

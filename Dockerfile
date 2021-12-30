FROM newrelic/cli:latest

RUN apk update \
 && apk add jq \
 && apk add git \
 && rm -rf /var/cache/apk/*

# Copies your code file from your action repository to the filesystem path `/` of the container
# COPY entrypoint.sh /entrypoint.sh
COPY entrypoint.sh /entrypoint.sh
COPY scripts/getChanges.awk /getChanges.awk

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]

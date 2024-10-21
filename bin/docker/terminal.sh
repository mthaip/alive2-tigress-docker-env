#!/bin/bash

# Load environment variables from .env file
set -o allexport; source "$(dirname "$0")/../../.env"; set +o allexport

# Check if the container is running
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    # Execute the command in the running container
    docker exec -it "$CONTAINER_NAME" "$@"
else
    echo "Container '$CONTAINER_NAME' is not running."
    exit 1
fi

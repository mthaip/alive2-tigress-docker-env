#!/bin/bash

# Load environment variables from .env file
set -o allexport; source "$(dirname "$0")/../../.env"; set +o allexport

# Run the Docker container for Alive2, mounting the scripts directory
docker run -it --name "$CONTAINER_NAME" -v ~/ll-scripts:/scripts "$IMAGE_NAME"

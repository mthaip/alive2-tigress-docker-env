#!/bin/bash

# Load environment variables from .env file
set -o allexport; source "$(dirname "$0")/../../.env"; set +o allexport

# Build the Docker image for Alive2
docker build -t "$IMAGE_NAME" .

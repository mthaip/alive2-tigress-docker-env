#!/bin/bash

# Create the alive2-scripts directory in the project root
mkdir -p "$(dirname "$0")/../ll-scripts"

# Load environment variables from .env file
set -o allexport; source "$(dirname "$0")/../../.env"; set +o allexport

bash bin/docker/build.sh

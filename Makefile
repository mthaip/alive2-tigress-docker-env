.PHONY: docker-build docker-run docker-stop

# Loads all variables
include .env
export $(shell sed 's/=.*//' .env)

# Removes "." in version code if exists
SANITIZED_UBUNTU_VERSION = $(subst .,,$(UBUNTU_VERSION))

DOCKER_IMAGE_NAME_WITH_TAG = "$$DOCKER_IMAGE_NAME:ubuntu-$(SANITIZED_UBUNTU_VERSION)-pkgver-$$PACKAGE_VERSION"
DOCKER_BUILD_CONTAINER = docker \
	run -it \
	--platform linux/amd64 \
	--name "$$DOCKER_IMAGE_NAME" \
	-v "./workspace:/workspace" \
	$(DOCKER_IMAGE_NAME_WITH_TAG)

docker-build:
	docker build \
	--platform linux/amd64 \
	-t $(DOCKER_IMAGE_NAME_WITH_TAG) \
	--build-arg PACKAGE_VERSION=$$PACKAGE_VERSION \
	--build-arg UBUNTU_VERSION=$$UBUNTU_VERSION .

docker-run:
	@if [ -z "$$DOCKER_IMAGE_NAME" ]; then \
	  echo "Error: DOCKER_IMAGE_NAME is not set in .env"; exit 1; \
	fi
	@if ! docker ps -aq -f name="$$DOCKER_IMAGE_NAME" | grep -q .; then \
	  echo "No existing container found. Running a new container..."; \
	  $(DOCKER_BUILD_CONTAINER); \
	elif [ "$$(docker inspect -f '{{.Config.Image}}' $$DOCKER_IMAGE_NAME)" != "$$DOCKER_IMAGE_NAME_WITH_TAG" ]; then \
	  echo "Warning: The container is not running the expected image! Re-run the container..."; \
		docker stop "$$DOCKER_IMAGE_NAME"; \
		docker rm "$$DOCKER_IMAGE_NAME"; \
		$(DOCKER_BUILD_CONTAINER); \
	elif [ "$$(docker inspect -f '{{.State.Running}}' $$DOCKER_IMAGE_NAME)" = "false" ]; then \
	  echo "Container exists but is stopped. Starting container..."; \
	  docker start -i "$$DOCKER_IMAGE_NAME"; \
	else \
	  echo "Container is already running. Accessing container..."; \
	  docker exec -it "$$DOCKER_IMAGE_NAME" /bin/sh; \
	fi

docker-stop:
	docker stop "$$DOCKER_IMAGE_NAME"

docker-remove:
	docker rm "$$DOCKER_IMAGE_NAME"
# 🐳 Dockerized Tigress Environment

This project provides a Docker-based environment for applying Tigress transformations to C code and verifying them using [online Alive2 compiler](https://alive2.llvm.org/ce/). The setup uses a Makefile and `.env` configuration to automate container creation and management.

## Project Structure

- `Dockerfile` - Docker image with Tigress + Alive2 setup
- `tigress_4.0.7-1_all.deb` - Tigress `.deb` package (offline installation)
- `Makefile` – Automates Docker image build and container control.
- `.env` – Contains configuration variables such as image name and version tags.
- `workspace/` – Directory mounted into the container for code and experiment files.

## Configuration

Edit the `.env` file to set your image and package versions:

```env
DOCKER_IMAGE_NAME=univie-bachelor-thesis
UBUNTU_VERSION=24.10
PACKAGE_VERSION=19
```

This will generate a Docker tag like:

`univie-bachelor-thesis:ubuntu-2410-pkgver-19`

## Usage

### Build the Docker Image

```bash
make docker-build
```

This builds the image using:
- The provided `Dockerfile`
- The Tigress `tigress_4.0.7-1_all.deb` package
- Ubuntu base image (`UBUNTU_VERSION`)

### Run or Attach to the Docker Container

```bash
make docker-run
```

This will:
- Start a new container if one doesn’t exist
- Rebuild and replace the container if the image has changed
- Attach to the container if it is already running

### Stop the Container

```bash
make docker-stop
```

Stops the running container without removing it.

### Remove the Container

```bash
make docker-remove
```

Removes the stopped container entirely.

## Notes

- `workspace/` is mounted as `/workspace` inside the container.
- The Docker image targets `linux/amd64` for Alive2 compatibility.
- Requires Docker and make installed on the host system.

# Use Ubuntu as the base image
FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
  build-essential \
  cmake \
  git \
  python3 \
  python3-pip \
  zlib1g-dev \
  libtinfo-dev \
  curl \
  libedit-dev \
  llvm-14 \
  clang-14 \
  lld-14 \
  ninja-build \
  re2c \
  && rm -rf /var/lib/apt/lists/*

# Clone and install hiredis
RUN git clone https://github.com/redis/hiredis.git /hiredis && \
  cd /hiredis && \
  make && \
  make install && \
  ldconfig && \
  rm -rf /hiredis

# Set environment variables
ENV LLVM_VERSION=14
ENV PATH="/usr/lib/llvm-${LLVM_VERSION}/bin:${PATH}"

# Clone Alive2 repository
RUN git clone https://github.com/AliveToolkit/alive2.git /alive2

# Create build directory and build Alive2
WORKDIR /alive2
RUN mkdir build && cd build && \
  cmake -GNinja .. && \
  ninja

# Set Alive2 bin directory in PATH
ENV PATH="/alive2/build:${PATH}"

# Set a working directory inside the container for your scripts
WORKDIR /scripts

# Set up entrypoint for running the compiler easily
ENTRYPOINT ["/alive2/build/alive-tv"]

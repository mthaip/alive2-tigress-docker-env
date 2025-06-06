ARG UBUNTU_VERSION="20.04"

FROM ubuntu:${UBUNTU_VERSION}

# Set environment variables for non-interactive setup and timezone
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Vienna 

# Define package version as an argument. Default 12
ARG PACKAGE_VERSION="12"

RUN apt-get update && \
    apt-get install -y \
    build-essential \
    git \
    llvm-${PACKAGE_VERSION} \
    clang-${PACKAGE_VERSION} \
    llvm-${PACKAGE_VERSION}-tools \
    lldb-${PACKAGE_VERSION} \
    && rm -rf /var/lib/apt/lists/*

# Set up symbolic links for tools
RUN for tool in $(find /usr/bin \
    -name "llvm-*${PACKAGE_VERSION}" \
    -o -name "clang-${PACKAGE_VERSION}" \
    -o -name "opt-${PACKAGE_VERSION}" \
    -o -name "lli-${PACKAGE_VERSION}"\
    ); \
    do ln -s "$tool" "/usr/bin/$(basename "$tool" -${PACKAGE_VERSION})"; \
    done

# NOTE: `tigress_4.0.7-1_all.deb` can be downloaded in https://tigress.wtf/tigress-download.html
COPY tigress_4.0.7-1_all.deb tigress-installer.deb
RUN dpkg --force-architecture -i tigress-installer.deb
# Link tigress.h globally
RUN ln -s "/usr/local/bin/tigresspkg/4.0.7/tigress.h" "/usr/local/include/tigress.h" # Change 4.0.7 to correct installed version

# Copy Makefile from host machine to root of OS
COPY Makefile /

ENV MAKEFILES=/Makefile

# Set the working directory
WORKDIR /workspace

ENTRYPOINT ["/bin/bash", "-c", "echo 'LLVM:' $(llvm-config --version) && echo '\nclang:' $(clang --version) '\n' && tigress --Version && echo '\n' && exec /bin/bash"]
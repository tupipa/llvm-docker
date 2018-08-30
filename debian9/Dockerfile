# Stage 1. Check out LLVM source code and run the build.
#FROM launcher.gcr.io/google/debian8:latest as builder
FROM debian:9 as builder
LABEL maintainer "Lele Ma"
# Install build dependencies of llvm.
# First, Update the apt's source list and include the sources of the packages.
RUN grep deb /etc/apt/sources.list | \
    sed 's/^deb/deb-src /g' >> /etc/apt/sources.list
# Install compiler, python and subversion.
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates gnupg \
           build-essential cmake python wget subversion unzip openssh-server nano git && \
    rm -rf /var/lib/apt/lists/*
# Install a newer ninja release. It seems the older version in the debian repos
# randomly crashes when compiling llvm.
RUN wget "https://github.com/ninja-build/ninja/releases/download/v1.8.2/ninja-linux.zip" && \
    echo "d2fea9ff33b3ef353161ed906f260d565ca55b8ca0568fa07b1d2cab90a84a07 ninja-linux.zip" \
        | sha256sum -c  && \
    unzip ninja-linux.zip -d /usr/local/bin && \
    rm ninja-linux.zip

ADD checksums /root/checksums
ADD scripts /root/scripts

# Checkout the source code.
ARG checkout_args
RUN /root/scripts/checkout.sh ${checkout_args}
# Run the build. Results of the build will be available at /usr/local/.
ARG buildscript_args
RUN /root/scripts/build_install_llvm.sh --to /usr/local ${buildscript_args}

WORKDIR /root
RUN echo "export PS1='\[\e]0;\u@\h: \w\a\]\[\033[01;32m\][\d \t UTC]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]# '" >> /root/.bashrc

ENTRYPOINT /usr/bin/bash /root/scripts/entrypoint.sh

# Stage 2. Produce a minimal release image with build results.
FROM debian:9
LABEL maintainer "Lele Ma"
# Install packages for minimal useful image.
RUN apt-get update && \
    apt-get install -y --no-install-recommends libstdc++-6-dev binutils && \
    rm -rf /var/lib/apt/lists/*
# Copy build results of stage 1 to /usr/local.
COPY --from=builder /usr/local/ /usr/local/


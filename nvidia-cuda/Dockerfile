#===- llvm/utils/docker/nvidia-cuda/build/Dockerfile ---------------------===//
#
#                     The LLVM Compiler Infrastructure
#
# This file is distributed under the University of Illinois Open Source
# License. See LICENSE.TXT for details.
#
#===----------------------------------------------------------------------===//
# Stage 1. Check out LLVM source code and run the build.
FROM nvidia/cuda:8.0-devel as builder
LABEL maintainer "LLVM Developers"
# Install llvm build dependencies.
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates cmake python \
        subversion ninja-build && \
    rm -rf /var/lib/apt/lists/*

ADD checksums /root/checksums
ADD scripts /root/scripts

# Checkout the source code.
ARG checkout_args
RUN /root/scripts/checkout.sh ${checkout_args}
# Run the build. Results of the build will be available at /root/clang-install/.
ARG buildscript_args
RUN /root/scripts/build_install_llvm.sh --to /root/clang-install ${buildscript_args}


# Stage 2. Produce a minimal release image with build results.
FROM nvidia/cuda:8.0-devel
LABEL maintainer "LLVM Developers"
# Copy clang installation into this container.
COPY --from=builder /root/clang-install/ /usr/local/
# C++ standard library and binutils are already included in the base package.

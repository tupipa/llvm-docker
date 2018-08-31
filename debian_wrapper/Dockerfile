FROM tupipa/clang-debian9


RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
           ca-certificates build-essential cmake python wget subversion unzip openssh-server nano git && \
    rm -rf /var/lib/apt/lists/*

ADD scripts /root/scripts
RUN cat /root/scripts/bashrc.append.txt >> /root/.bashrc \
    && cat /root/scripts/root_nanorc >> /root/.nanorc


# Install a newer ninja release. It seems the older version in the debian repos
# randomly crashes when compiling llvm.

WORKDIR /root

# entrypoint will let container exit after creation. why.
# ENTRYPOINT /bin/bash /root/scripts/entrypoint.sh


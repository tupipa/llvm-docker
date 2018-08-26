

## Build LLVM with Clang in Docker container

### 1. start container

This step requires Docker CE to be installed. You can following [this post](https://docs.docker.com/install/) to install Docker, or a simpler routine [using snap](https://github.com/docker/docker-snap), like this:

	sudo snap install docker

After Docker installed. You can now download this repo and start the container with all dependencies installed to build LLVM with Clang. 


	git clone https://github.com/tupipa/llvm-docker.git
	cd llvm-docker/

	sudo bash start_container.sh  <shared_directory>

**<shared_directory>** is the directory on your host shared with the container (default will be mounted to /root/llvm in container).

### 2. prepare directory path for clang build

Assume the container & host shared directory is /root/llvm. 
Run the following commands in the container


    # link clang-build directory to container's /root dir:
	
    mkdir /root/llvm/clang-build  # no need to create if exists

    ln -s /root/llvm/clang-build /root/clang-build
    
By default (unless changed in scripts/*.sh), clang build dir and source are all in /root/clang-build in the container. Linking this directory from outside allows any changes to be saved out of the container. 

### 3. checkout source code (skip this if the code are all in place)

In container, the source code of clang build will be downloaded to /root/clang-build/src by running the following commands:
	
	cd /root/scripts
	bash checkout_wrapper.sh


### 4. build LLVM with Clang

In container, run the following commands to build:

	cd /root/scripts
	bash rebuild_clang.sh

These commands will build and install clang by running two commands:
``cmake`` (to generate Makefiles) and ``ninja`` (to build the source code). The actual commands will be printed to the console when all finished. So keep your record and you can run them manually in case you need to. Of course, you can also manually change them accordingly.

For example, the commands to build the clang source code look like:


	# cmake COMMAND:
	cmake -GNinja -DCMAKE_INSTALL_PREFIX="/usr/local" -DLLVM_TARGETS_TO_BUILD=Native -DCMAKE_BUILD_TYPE=Release -DBOOTSTRAP_CMAKE_BUILD_TYPE=Release -DCLANG_ENABLE_BOOTSTRAP=ON -DCLANG_BOOTSTRAP_TARGETS=install-clang;install-clang-headers -DLLVM_ENABLE_PROJECTS=clang "/root/clang-build/src/llvm"
	
	# ninja COMMAND:
	ninja  stage2-install-clang stage2-install-clang-headers
	

### 5. Test Clang

In container, you can run clang:
	
	clang --version

example outputs would be 

	[Sat Aug 25 21:27:52 UTC]root@3c0a5be47c41:~# clang --version
	clang version 8.0.0 (trunk 340678)
	Target: x86_64-unknown-linux-gnu
	Thread model: posix
	InstalledDir: /usr/local/bin
	[Sat Aug 25 21:27:55 UTC]root@3c0a5be47c41:~# 

More links about how to use clang:

- [Understanding the Clang AST](https://jonasdevlieghere.com/understanding-the-clang-ast/)
- [Clang Totorial (CS453 Automated Software Testing)](http://swtv.kaist.ac.kr/courses/cs453-fall13/Clang%20tutorial%20v4.pdf)
- [Code Transformation using Clang: building tools using LibTooling and LibASTMatchers](http://clang.llvm.org/docs/LibASTMatchersTutorial.html)

## Build Your Own Container Image

You can build your own container image as well by running ``[build_docker_image.sh](https://github.com/tupipa/llvm-docker/blob/master/build_docker_image.sh)``.

Now that this repo is different from the build scripts in  [original LLVM repo](https:/github.com/llvm-mirror/llvm.git). This repo has only one stage build. It only installs the dependences of building llvm/clang, but will not build llvm/clang. This aims to be a start point for the user to customize their own building enviroment. 

For example: 

	./build_docker_image.sh -s debian8 -d mydocker/clang-debian8 -t "dev" \ 
    -p clang -i stage2-install-clang -i stage2-install-clang-headers \ 
    -- \ 
    -DLLVM_TARGETS_TO_BUILD=Native -DCMAKE_BUILD_TYPE=Release \ 
    -DBOOTSTRAP_CMAKE_BUILD_TYPE=Release \ 
    -DCLANG_ENABLE_BOOTSTRAP=ON \ 
    -DCLANG_BOOTSTRAP_TARGETS="install-clang;install-clang-headers"

will build image as ``mydocker/clang-debian8:dev``. 


## More info:
  See [llvm/docs/Docker.rst](https://github.com/tupipa/llvm/blob/master/docs/Docker.rst) for details

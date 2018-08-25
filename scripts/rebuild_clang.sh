#!/bin/bash

buildscript="./build_install_llvm.sh"

buildscript_args=" -i stage2-install-clang -i stage2-install-clang-headers -- -DLLVM_TARGETS_TO_BUILD=Native -DCMAKE_BUILD_TYPE=Release -DBOOTSTRAP_CMAKE_BUILD_TYPE=Release -DCLANG_ENABLE_BOOTSTRAP=ON -DCLANG_BOOTSTRAP_TARGETS=install-clang;install-clang-headers -DLLVM_ENABLE_PROJECTS=clang"


$buildscript --to /usr/local $buildscript_args



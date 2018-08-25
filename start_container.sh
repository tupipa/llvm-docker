#!/bin/bash



# get current directory

#cite: https://stackoverflow.com/questions/59895/getting-the-source-directory-of-a-bash-script-from-within
#scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#sharedDir="$(cd ../.. && pwd)"
#echo "set par of par dir as workdir: $sharedDir" 

function Usage {
  echo "*************************"
  echo "Usage: "
  echo ""
  echo "    $0  <shared_dir_full_path>"
  echo ""
  echo "Parameters:"
  echo ""
  echo " <shared_dir_full_path>: "
  echo "      a directory on your host in full path. This will be the shared directory between docker container and the host machine."
  echo ""
  echo "*************************"
  echo ""

}

if [ "$1" = "" ];then
  echo "please give the directory on your host machine to be shared with the container"
  echo ""
  Usage
  exit 1
fi

if [ "$#" -ne "1" ];then
   Usage
   exit 1
fi

sharedDir=$1
sharedDirInContainer="/root/llvm"

if [ ! -d "$sharedDir" ];then

  if [ -e "$sharedDir" ];then
    echo "ERROR: shared dir cannot be a file: $sharedDir"
  fi

  echo "directory does not exits for: $sharedDir"

  echo ""

  Usage

  exit 1

fi


echo "use shared dir $sharedDir"

echo "find HOWTOs at README.md"

sudo docker run -ti --name=clang-dev -v $sharedDir:$sharedDirInContainer tupipa/clang-debian8:latest 

if [ "$?" -ne "0" ];then
  echo ""
  echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
  echo "Oops!! Container failed to start"
  echo "please check the error messages above and figure it out"
  echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^" 
  echo ""
  exit 1
fi


#echo ""
#echo "congratulations!! container started successfully!!"
#echo ""
#echo "the shared directory:"
#echo "Host: $sharedDir  <--> Container: $sharedDirInContainer"



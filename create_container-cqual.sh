#!/bin/bash

###########################################
# To customize the script

maxMem="8g" # main memory limit for container, e.g. "2048m", "2g", etc.
maxMemSwap="16g" # maximum size of memory and swap size combined. -1 will allow container to use unlimited swap available on host.
maxCPUs="3" # number of cpu resources the container can use

containerImage="ubuntu:12.04"
containerName="oink"
sshPort="8801"
workdir="oink"

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
sharedDirInContainer="/root/$workdir"

if [ ! -d "$sharedDir" ];then

  if [ -e "$sharedDir" ];then
    echo "ERROR: shared dir cannot be a file: $sharedDir"
  fi

  echo "directory does not exits for: $sharedDir"

  echo ""

  Usage

  exit 1

fi


echo "use container image: $containerImage"
echo "use container name: $containerName"
echo "use shared dir $sharedDir"
echo "open ssh port: $sshPort"

docker run -ti --memory="$maxMem" --memory-swap="$maxMemSwap" --cpus="$maxCPUs" --name=$containerName -v $sharedDir:$sharedDirInContainer -p $sshPort:22 $containerImage

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



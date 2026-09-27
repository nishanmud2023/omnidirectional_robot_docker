#!/usr/bin/env bash

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
EXEC_PATH=$PWD

cd $ROOT_DIR
source $ROOT_DIR/.env

USERNAME=$(whoami)
SSH_PATH="/home/${USERNAME}/.ssh"

# Checking for folder existence
if [ -d "$SSH_PATH" ]; then
  cp -r ${SSH_PATH} $EXEC_PATH/..
else
  echo "The folder ${SSH_PATH} does not exist."
  exit 1
fi

if [[ $1 = "--nvidia" ]] || [[ $1 = "-n" ]]
  then
    docker build -t "$APP_NAME"-img -f $ROOT_DIR/docker/Dockerfile $ROOT_DIR \
                                  --network=host \
                                  --build-arg from=nvidia/cuda:12.1.0-base-ubuntu24.04 \
                                  --build-arg USERNAME=$(whoami)


else
    echo "[!] If you use nvidia gpu, please rebuild with -n or --nvidia argument"
    docker build -t "$APP_NAME"-img -f $ROOT_DIR/docker/Dockerfile $ROOT_DIR \
                                  --network=host \
                                  --build-arg from=ros:jazzy \
                                  --build-arg USERNAME=$(whoami)
fi

cd $EXEC_PATH

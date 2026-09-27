#!/bin/bash

xhost +local:docker || true

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
echo $ROOT_DIR

source $ROOT_DIR/.env

if [[ $1 = "--nvidia" ]] || [[ $1 = "-n" ]]
  then
    docker run --gpus all \
                -ti --rm \
                -e "DISPLAY" \
                -e "QT_X11_NO_MITSHM=1" \
                -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
                -e XAUTHORITY \
                -v /dev:/dev \
               -v $ROOT_DIR/workspace:/ws_slam \
               --net=host \
               --privileged \
               --name "$APP_NAME" "$APP_NAME"-img

else

    echo "[!] If you wanna use nvidia gpu, please use script with -n or --nvidia argument"
    docker run  -ti --rm \
                -e "DISPLAY" \
                -e "QT_X11_NO_MITSHM=1" \
                -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
                -e XAUTHORITY \
                -v /dev:/dev \
                -v $ROOT_DIR/workspace:/ws_slam \
                -v /var/run/dbus:/var/run/dbus \
               -v /run/bluetooth:/run/bluetooth \
               --device /dev/bus/usb \
               --net=host \
               --privileged \
               --name "$APP_NAME" "$APP_NAME"-img
fi

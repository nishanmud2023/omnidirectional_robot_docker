#!/usr/bin/env bash

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

source $ROOT_DIR/.env

sudo docker exec -ti "$APP_NAME" bash

#!/bin/bash
set -e

DOCKER_RUN_IMAGE=nginx-rtmp-arm
DOCKER_BUILD_IMAGE=nginx-arm-build

rm -f nginx.tar.gz

cd build

docker build -t ${DOCKER_BUILD_IMAGE} .

cd ..

DID=`docker create ${DOCKER_BUILD_IMAGE}`

docker cp ${DID}:/tmp/nginx.tar.gz ./

docker rm ${DID}
docker rmi ${DOCKER_BUILD_IMAGE}

docker build -t ${DOCKER_RUN_IMAGE} .

docker images 
docker run -d --name streamserver --restart always -p 8800:80 -p 1935:1935 -t ${DOCKER_RUN_IMAGE}
docker ps -a


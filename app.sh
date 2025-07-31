#!/bin/bash

IMAGE="ghcr.io/babelcloud/appium"

if [ -z "$1" ]; then
	read -p "Task (test|build|push) : " TASK
else
	TASK=$1
fi

if [ -z "$2" ]; then
	read -p "Version : " VER
else
	VER=$2
fi

function build() {
	echo "Build docker image with version \"${VER}\""
	docker build --no-cache -t ${IMAGE}:${VER} -f Appium/Dockerfile Appium
	docker images ${IMAGE}:${VER}
}

function buildx() {
	echo "Build docker image with version \"${VER}\""
	docker buildx build \
	   --platform linux/amd64,linux/arm64 \
	   --push \
	   --annotation org.opencontainers.image.source=https://github.com/babelcloud/appium \
	   -t ${IMAGE}:${VER} \
	   -f Appium/Dockerfile \
	   Appium
	docker images ${IMAGE}:${VER}
}

function test() {
	echo "Test docker image with version \"${VER}\""
	docker run --rm -v $PWD/Appium/tests:/home/androidusr/appium-docker-android/tests ${IMAGE}:${VER} ./appium-docker-android/tests/run-bats.sh
}

function push() {
	echo "Push docker image with version \"${VER}\""
	docker push ${IMAGE}:${VER}
	docker tag ${IMAGE}:${VER} ${IMAGE}:latest
	docker push ${IMAGE}:latest
}

case $TASK in
build)
	build
	;;
buildx)
	buildx
	;;
test)
	test
	;;
push)
	push
	;;
*)
	echo "Invalid environment! Valid options: test, build, push"
	;;
esac

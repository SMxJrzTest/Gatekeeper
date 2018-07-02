#!/bin/bash

DOCKER_TAG=$1
DOCKER_TAG_COMPONENT=$2

DOCKER_REPO=${DOCKER_USER}/${DOCKER_TAG_COMPONENT}

CIRCLE_BRANCH=$(echo "$CIRCLE_BRANCH")
CIRCLE_TAG=$(echo "$CIRCLE_TAG")
CIRCLE_BUILD_NUM=$(echo "$CIRCLE_BUILD_NUM")

if [[ -z "${CIRCLE_BRANCH}" ]]; then
    echo "This is a CI branch build"
    DOCKER_RELEASE_TAG=${CIRCLE_BRANCH}-latest
    DOCKER_LATEST_TAG=${CIRCLE_BRANCH}-${CIRCLE_BUILD_NUM}
    echo "Tag will be: ${DOCKER_RELEASE_TAG}"
else
    echo "This is a Tag release"
    DOCKER_RELEASE_TAG=$(echo $CIRCLE_TAG | cut -d "v" -f 2)
    DOCKER_LATEST_TAG=latest
fi

echo "Version Tag will be: ${DOCKER_RELEASE_TAG}"
echo "Latest Tag will be: ${DOCKER_LATEST_TAG}"

echo "pushing and tagging image"
docker tag ${DOCKER_TAG} ${DOCKER_REPO}:${DOCKER_RELEASE_TAG}
docker tag ${DOCKER_TAG} ${DOCKER_REPO}:${DOCKER_LATEST_TAG}
docker images
docker login -u=${DOCKER_USER} -p=${DOCKER_PASS}
docker push ${DOCKER_REPO}:${DOCKER_RELEASE_TAG}
docker push ${DOCKER_REPO}:${DOCKER_REPO}:${DOCKER_LATEST_TAG}
echo "Done"

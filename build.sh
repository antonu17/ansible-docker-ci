#!/bin/bash
set -e

# This dir
SETUP_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $SETUP_DIR

# Current Version
version="$(cat Version)"
# We use quay
DOCKER_REG="quay.io"
DOCKER_ORG="hellofresh"
DOCKER_IMAGE="ci-ansible"

DOCKER_VERSION="${DOCKER_REG}/${DOCKER_ORG}/${DOCKER_IMAGE}:${version}"
DOCKER_LATEST="${DOCKER_REG}/${DOCKER_ORG}/${DOCKER_IMAGE}:latest"

echo "******* BUILDING *******"
docker build --no-cache=True -t ${DOCKER_VERSION} -t ${DOCKER_LATEST} -f Dockerfile .
echo ""

#echo "******* TESTING *******"
#bundle exec rspec
#echo ""

echo "******* PUSHING *******"
echo "   ${DOCKER_VERSION}"
docker push ${DOCKER_VERSION}

echo "   ${DOCKER_LATEST}"
docker push ${DOCKER_LATEST}
exit 0

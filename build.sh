#!/bin/bash
set -e

# This dir
SETUP_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $SETUP_DIR

# Current Version
version="0.2.0"
# We use quay
DOCKER_REG="quay.io"
DOCKER_ORG="hellofresh"
DOCKER_IMAGE="ci-ansible"

DOCKER_STRING="${DOCKER_REG}/${DOCKER_ORG}/${DOCKER_IMAGE}:${version}"

echo "******* BUILDING *******"
docker build --no-cache=True -t ${DOCKER_STRING} -f Dockerfile .
echo ""

#echo "******* TESTING *******"
#bundle exec rspec
#echo ""

echo "******* PUSHING *******"
echo "   ${DOCKER_STRING}"
docker push ${DOCKER_STRING}

exit 0

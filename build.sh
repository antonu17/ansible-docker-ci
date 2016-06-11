#!/bin/bash
set -e

# This dir
SETUP_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $SETUP_DIR

# Current Version
version="$(cat VERSION)"
# We use quay
version_name="$(cat VERSION_NAME)"


DOCKER_VERSION="${version_name}:${version}"
DOCKER_LATEST="${version_name}:latest"

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

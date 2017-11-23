#!/bin/bash

set -e

if [[ ! "${TRAVIS}" ]]; then
  echo "This script should be only run from travis-ci. Exiting."
  exit 0
fi

CHANGES=$(git diff --name-only $TRAVIS_COMMIT_RANGE)
[ -n "$(grep "^${VERSION}" <<< "$CHANGES")" ] && BUILD_REQUIRED=1

if [[ -z ${BUILD_REQUIRED} ]]; then
  echo "Version ${VERSION} wasn't changed. Nothing to do."
  exit 0
fi

docker build -t ${IMAGE}:${VERSION} ${VERSION}/

if [[ $TRAVIS_PULL_REQUEST == "false" ]] && [[ $TRAVIS_BRANCH == "master" ]]; then
  docker login -u="${QUAY_USER}" -p="${QUAY_PASS}" quay.io
  docker push ${IMAGE}:${VERSION}
else
  echo "Pull request build, don't push images"
fi

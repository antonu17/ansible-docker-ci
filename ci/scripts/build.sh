#!/bin/bash

set -ex

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

echo docker build -t ${IMAGE}:${VERSION} ${VERSION}/

if [[ $TRAVIS_PULL_REQUEST == "false" ]]; then
  echo docker login -u="${QUAY_USER}" -p="${QUAY_PASS}" quay.io
  echo docker push ${IMAGE}:${VERSION}
else
  echo "Pull request build, don't push images"
fi

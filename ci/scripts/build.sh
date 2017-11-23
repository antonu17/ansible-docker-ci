#!/bin/bash

set -e

ci/scripts/build-images.sh

if [[ -z "${TRAVIS_PULL_REQUEST}" ]]; then
  ci/scripts/push-images.sh
else
  echo "Pull request build, don't push images"
fi

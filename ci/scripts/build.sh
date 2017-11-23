#!/bin/bash

set -ex

ci/scripts/build-images.sh

if [[ -z "${TRAVIS_PULL_REQUEST}" ]]; then
  ci/scripts/push-images.sh
fi

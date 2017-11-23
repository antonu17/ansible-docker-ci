#!/bin/bash

set -ex

#ci/scripts/build-images.sh
[[ -n ${TRAVIS_PULL_REQUEST} ]] && ci/scripts/push-images.sh

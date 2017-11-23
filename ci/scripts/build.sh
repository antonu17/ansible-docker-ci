#!/bin/bash

set -ex

ci/scripts/build-images.sh
[[ -z ${TRAVIS_PULL_REQUEST} ]] && ci/scripts/push-images.sh

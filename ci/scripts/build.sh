#!/bin/bash

set -eux

ci/scripts/build-images.sh
[[ $TRAVIS_PULL_REQUEST -ne "1" ]] && ci/scripts/push-images.sh

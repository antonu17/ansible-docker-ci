#!/bin/bash

[[ $TRAVIS_PULL_REQUEST == "1" ]] && ci/scripts/build-pr.sh

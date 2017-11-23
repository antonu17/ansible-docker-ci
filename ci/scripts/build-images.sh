#!/bin/bash

set -ex

CHANGES=$(git --no-pager diff --name-only FETCH_HEAD $(git merge-base FETCH_HEAD master))  
[ -n "$(grep "^${VERSION}" <<< "$CHANGES")" ] && BUILD_REQUIRED=1

if [[ -n "$BUILD_REQUIRED" ]]; then
  docker build -t ${IMAGE}:${VERSION} ${VERSION}/
fi

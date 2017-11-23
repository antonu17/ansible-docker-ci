#!/bin/bash

set -e

if [[ $TRAVIS_PULL_REQUEST == "false" ]] && [[ $TRAVIS_BRANCH == "master" ]]; then
  CHANGES=$(git --no-pager diff --name-only FETCH_HEAD $(git merge-base FETCH_HEAD master))  
  [ -n "$(grep "^${VERSION}" <<< "$CHANGES")" ] && BUILD_REQUIRED=1

  if [[ -n "${BUILD_REQUIRED}" ]]; then
    echo docker login -u="${QUAY_USER}" -p="${QUAY_PASS}" quay.io
    echo docker push ${IMAGE}:${VERSION}
  else
    echo "Version ${VERSION} wasn't changed. Not pushing."
  fi
fi

#!/bin/bash

set -eux

CHANGES=$(git --no-pager diff --name-only FETCH_HEAD $(git merge-base FETCH_HEAD master))  
[ -n "$(grep '^2.2.1.0' <<< "$CHANGES")" ] && BUILD_22=1
[ -n "$(grep '^2.3.2.0' <<< "$CHANGES")" ] && BUILD_23=1

if [ -z "$BUILD_22" ]; then
  docker build -t ${IMAGE}:2.2.1.0 2.2.1.0/
fi

if [ -z "$BUILD_23" ]; then
  docker build -t ${IMAGE}:2.3.2.0 2.3.2.0/
fi

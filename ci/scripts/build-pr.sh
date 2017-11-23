#!/bin/bash

CHANGES=$(git --no-pager diff --name-only FETCH_HEAD $(git merge-base FETCH_HEAD master))  
[ -n "$(grep '^2.2.1.0' <<< "$CHANGES")" ] && BUILD_22=1
[ -n "$(grep '^2.3.2.0' <<< "$CHANGES")" ] && BUILD_23=1

echo $BUILD_22
echo $BUILD_23

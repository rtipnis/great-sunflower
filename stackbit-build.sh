#!/usr/bin/env bash

set -e
set -o pipefail
set -v

initialGitHash=$(git rev-list --max-parents=0 HEAD)
node ./studio-build.js $initialGitHash &

curl -s -X POST https://api.stackbit.com/project/5eac9bf947dd930019bb0a6c/webhook/build/pull > /dev/null
npx @stackbit/stackbit-pull --stackbit-pull-api-url=https://api.stackbit.com/pull/5eac9bf947dd930019bb0a6c
curl -s -X POST https://api.stackbit.com/project/5eac9bf947dd930019bb0a6c/webhook/build/ssgbuild > /dev/null
jekyll build
wait

curl -s -X POST https://api.stackbit.com/project/5eac9bf947dd930019bb0a6c/webhook/build/publish > /dev/null
echo "Stackbit-build.sh finished build"

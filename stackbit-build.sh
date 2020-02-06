#!/usr/bin/env bash

set -e
set -o pipefail
set -v

initialGitHash=$(git rev-list --max-parents=0 HEAD)
node ./studio-build.js $initialGitHash &

curl -s -X POST https://rob-stackbit.ngrok.io/project/5e3bc9e6939327ce23170c50/webhook/build/pull > /dev/null
npx @stackbit/stackbit-pull --stackbit-pull-api-url=https://rob-stackbit.ngrok.io/pull/5e3bc9e6939327ce23170c50
curl -s -X POST https://rob-stackbit.ngrok.io/project/5e3bc9e6939327ce23170c50/webhook/build/ssgbuild > /dev/null
hugo
wait

curl -s -X POST https://rob-stackbit.ngrok.io/project/5e3bc9e6939327ce23170c50/webhook/build/publish > /dev/null
echo "Stackbit-build.sh finished build"

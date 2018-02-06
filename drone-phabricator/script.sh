#!/bin/bash

export PATH=$PATH:~/phacility/arcanist/bin/

function isPullRequest {
  [ "$1" == "pull_request" ]
}

function isTag {
  [[ "$1" == "tag" ]] && [[ "$2" == refs/tags/* ]]
}

function trace {
  echo "+$@"
  $@ || exit 1
}

echo "machine $CI_NETRC_MACHINE
login $CI_NETRC_USERNAME
password $CI_NETRC_PASSWORD" > ~/.netrc

echo "[user]
  email = you@example.com
  name = Your Name" > ~/.gitconfig

CI_CONDUIT_SERVER=$(echo $CI_COMMIT_REFSPEC | cut -d ',' -f 1)
CI_CONDUIT=$(echo $CI_COMMIT_REFSPEC | cut -d ',' -f 2)
CI_DIFF_ID=$(echo $CI_COMMIT_REFSPEC | cut -d ',' -f 3)

echo "{
  \"hosts\": {
    \"$CI_CONDUIT_SERVER/api/\": {
      \"token\": \"$CI_CONDUIT\"
    }
  },
  \"config\": {
    \"default\": \"$CI_CONDUIT_SERVER\"
  }
}" > ~/.arcrc && chmod 600 ~/.arcrc

mkdir -p 777 $CI_WORKSPACE

cd $CI_WORKSPACE

if [ ! -e $CI_WORKSPACE/.git ]; then
  trace git init
  trace git remote add origin $CI_REMOTE_URL
fi

trace git fetch --no-tags origin +$CI_COMMIT_REF:

if isPullRequest $CI_BUILD_EVENT || isTag $CI_BUILD_EVENT $CI_COMMIT_REF; then
  trace git checkout -qf FETCH_HEAD
else
  trace git reset --hard -q $CI_COMMIT_SHA
fi

if isPullRequest $CI_BUILD_EVENT; then
  trace arc patch D"$CI_DIFF_ID"
fi

trace git submodule update --init --recursive

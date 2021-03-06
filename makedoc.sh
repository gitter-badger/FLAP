#!/bin/bash
GITREPO=$1
FoBiS.py rule -ex makedoc
if [[ "${TRAVIS}" = "true" && "${TRAVIS_PULL_REQUEST}" != "false" ]]; then
    # Running under travis during a PR. No access to GH_TOKEN so abort
    # documentation deployment, without throwing an error
    exit 0
else
    # either we are not on TRAVIS and maybe you want to manually dpeloy documentation
    # or we are on TRAVIS but not testing a PR so it is safe to deploy documentation
    git config --global user.name "Stefano Zaghi"
    git config --global user.email "stefano.zaghi@gmail.com"
    git clone --branch=gh-pages https://${GH_TOKEN}@github.com/szaghi/$GITREPO doc/html
    cd doc/html
    git add -f --all *
    git commit -m "Travis CI autocommit from travis build ${TRAVIS_BUILD_NUMBER}"
    git push -f origin gh-pages
fi

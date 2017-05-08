#!/usr/bin/env bash

FILE=$1
TMPFILES=/tmp/truffle-tests

if [ ! -f $FILE ]; then
  echo "File $FILE does not exist"
  exit 1
fi

REPOS=($(cat $FILE))

mkdir -pv $TMPFILES

cd $TMPFILES

for ((i=0; i < $((${#REPOS[@]})); i=$i+2)); do
  repo=${REPOS[$i]}
  folder=${REPOS[$((i+1))]}
  name=$(basename $repo)

  (
    if [ ! -d $name ]; then
      git clone $repo || {
        echo "Failed to clone repo $repo"
        echo "Skipping.."
        exit 2
      }
    fi

    cd $name
    cd $folder

    echo "NPM Install"
    npm i
    
    echo "Create migrations folder"
    mkdir -p migrations

    echo "Run Truffle Tests"
    truffle test
  )
done

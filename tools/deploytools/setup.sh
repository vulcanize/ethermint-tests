#!/usr/bin/env bash

source ./vars.sh

NETWORK=$1
NAME=$2
TMPFILES="/tmp/$TMPROOT/$NETWORK-$NAME"

TENDERMINT=$(which tendermint)
ETHERMINT=$(which ethermint)
EXEC=$(which geth)

KEYS=$(ls $KEYSTORE)


mkdir -p $TMPFILES
cp -rv keystore/ $TMPFILES/keystore

if [ "$NETWORK" == "ethermint" ]; then
  cp -v ./priv_validator.json $TMPFILES
  cp -v ./genesis.json $TMPFILES
  cd $TMPFILES
  $TENDERMINT init
  cd -
  EXEC=$ETHERMINT
fi

$EXEC --datadir $TMPFILES init ./ethgen.json

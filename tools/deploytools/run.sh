#!/usr/bin/env bash

function join_by { local IFS="$1"; shift; echo "$*"; }

source ./vars.sh

NAME=$1
NETWORK=$2
KEYSTORE=./keystore
DATADIR="${TMPROOT}/$NETWORK-$NAME"

if [ "$DATADIR" == "" ]; then
  echo "Provide Datadir"
  exit 1
fi

if [ "$NETWORK" == "" ]; then
  echo "Provide Network"
  exit 1
fi

KEYS=$(join_by , $(ls $KEYSTORE))
PASS=./passwords
FLAGS=(--datadir $DATADIR \
  --rpc --rpcapi eth,net,web3,personal,miner,admin \
  --rpcaddr 127.0.0.1
  --unlock $KEYS --password $PASS \
)

if [ "$NETWORK" == "ethereum" ]; then
  geth version
  #geth --mine --nodiscover --maxpeers 0 ${FLAGS[@]} &

  geth --fakepow --nodiscover --maxpeers 0 ${FLAGS[@]} &
  echo "miner.start(1)" | geth attach http://localhost:8545/
  wait
else
  echo $NETWORK ${FLAGS[@]}
  $NETWORK ${FLAGS[@]} &
  echo "personal.listAccounts.forEach(function (a) { personal.unlockAccount(a, ''); });" | geth attach http://localhost:8545
fi

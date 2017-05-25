#!/usr/bin/env bash

function join_by { local IFS="$1"; shift; echo "$*"; }

source ./vars.sh

NETWORK=$1
NAME=$2
PORT=$3
KEYSTORE=./keystore
DATADIR="/tmp/${TMPROOT}/$NETWORK-$NAME"

if [ "$DATADIR" == "" ]; then
  echo "Provide Datadir"
  exit 1
fi

if [ "$NETWORK" == "" ]; then
  echo "Provide Network"
  exit 1
fi

if [ "$PORT" == "" ]; then
  PORT="8545"
fi

KEYS=$(join_by , $(ls $KEYSTORE))
PASS=./passwords
FLAGS=(--datadir $DATADIR/$NETWORK \
  --rpc --rpcapi eth,net,web3,personal,miner,admin \
  --rpcaddr 127.0.0.1 --rpcport $PORT \
  --ws --wsapi eth,net,web3,personal,miner,admin \
  --wsaddr 127.0.0.1 --wsport 8546 \
  --unlock $KEYS --password $PASS \
)

if [ "$NETWORK" == "ethereum" ]; then
  geth version
  geth --mine --nodiscover --maxpeers 0 ${FLAGS[@]} &
  #geth --mine --fakepow --nodiscover --maxpeers 0 ${FLAGS[@]} &

  geth --fakepow --nodiscover --maxpeers 0 ${FLAGS[@]} &
  sleep 2
  echo "Running miner"
  echo "miner.start(1)" | geth attach http://127.0.0.1:$PORT/
  wait
else
  tendermint node --home $DATADIR/tendermint &
  ethermint ${FLAGS[@]} &
  sleep 2
  echo "personal.listAccounts.forEach(function (a) { personal.unlockAccount(a, '', 6000); });" | geth attach http://localhost:8545
  wait
fi

#!/usr/bin/env bash

TMPDIR=/tmp/truffle-tests
TESTNAME=test1
TRUFFLE=$1

if [ "$TRUFFLE" == "" ]
then
  echo "pass truffle repos file"
  exit 1
fi

ethermint version
geth version

# Start Ethereuum
cd deploytools
echo "Starting Ethereum"
./clean.sh && ./setup-ethereum.sh $TESTNAME && ./run-ethereum.sh $TESTNAME &
sleep 10

# Run Tests
cd ..
echo "Running Tests"
./ether-test.sh $TRUFFLE > $TMPDIR/$TESTNAME.output.ethereum

# Stop Ethereum
echo "Killing GETH"
killall geth

## Start Ethermint
cd deploytools
echo "Starting Ethermint"
./clean.sh && ./setup-ethermint.sh $TESTNAME && ./run-ethermint.sh $TESTNAME &
sleep 10

## Run Tests
cd ..
echo "Running Tests"
./ether-test.sh $TRUFFLE > $TMPDIR/$TESTNAME.output.ethermint


### Stop Ethermint
echo "Killing Ethermint and tendermint"
killall ethermint
killall tendermint

cd deploytools/
./clean.sh

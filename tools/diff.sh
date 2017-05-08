#!/usr/bin/env bash

TMPDIR=/tmp/truffle-tests
TESTNAME=test1


diff <(cat $TMPDIR/$TESTNAME.output.ethereum | sed 's/(.*)//') \
    <(cat $TMPDIR/$TESTNAME.output.ethermint | sed 's/(.*)//')

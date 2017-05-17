#!/usr/bin/env bash

source ./vars.sh

echo "removing root directory: $TMPROOT"
rm -rvf /tmp/$TMPROOT/*

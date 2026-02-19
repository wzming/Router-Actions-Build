#!/bin/bash

cd $GITHUB_WORKSPACE

git clone --depth 1 -b ax6000 --single-branch $1 config
cd $GITHUB_WORKSPACE/config
mkdir -p $GITHUB_WORKSPACE/openwrt/files
mv etc $GITHUB_WORKSPACE/openwrt/files/
mv root $GITHUB_WORKSPACE/openwrt/files/
#!/bin/bash

set -e

cd $GITHUB_WORKSPACE/openwrt
#OAF
rm -rf feeds/packages/net/open-app-filter
git clone --depth 1 https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter





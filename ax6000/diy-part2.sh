#!/bin/bash

set -e

cd $GITHUB_WORKSPACE/openwrt
#OAF
rm -rf feeds/packages/net/open-app-filter
git clone --depth 1 https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter

sed -i '/^[[:space:]]*+luci-app-attendedsysupgrade/d;/luci-app-package-manager/s/[[:space:]]*\\$//' feeds/luci/collections/luci/Makefile
sed -i '/+luci-app-attendedsysupgrade/d;/+luci-theme-bootstrap/d;/^$/d'  feeds/luci/collections/luci-nginx/Makefile




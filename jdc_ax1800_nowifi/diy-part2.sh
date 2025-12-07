#!/bin/bash
cd /workdir/openwrt
#OAF
rm -rf feeds/packages/net/open-app-filter
git clone --depth 1 https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter

sed -i 's/--set=llvm\.download-ci-llvm=true/--set=llvm.download-ci-llvm=false/' feeds/packages/lang/rust/Makefile
# 删除nginx导入的无用包
sed -i '/+luci-app-attendedsysupgrade/d;/+luci-theme-bootstrap/d;/^$/d'  feeds/luci/collections/luci-nginx/Makefile
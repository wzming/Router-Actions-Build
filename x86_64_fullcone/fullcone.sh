#!/bin/bash
cd /workdir/openwrt
git clone --depth 1 https://github.com/fullcone-nat-nftables/nft-fullcone.git package/fullcone
#fullcone net
cd /workdir
git clone --depth 1 https://github.com/wongsyrone/lede-1.git fullcone
cd fullcone
cp -r package/network/utils/nftables/patches /workdir/openwrt/package/network/utils/nftables
cp -r package/network/config/firewall4/patches /workdir/openwrt/package/network/config/firewall4
cp -r package/libs/libnftnl/patches /workdir/openwrt/package/libs/libnftnl
#libnftnl
sed -i 's/PKG_LICENSE_FILES:=COPYING/PKG_LICENSE_FILES:=COPYING \nPKG_FIXUP:=autoreconf/g' /workdir/openwrt/package/libs/libnftnl/Makefile
#luci界面打补丁
git -C /workdir/openwrt/feeds/luci apply --ignore-space-change --ignore-whitespace $GITHUB_WORKSPACE/$FULLCONE_PATCH_PATH

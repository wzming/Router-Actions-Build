#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# openclash
cd /workdir
git clone --depth=1 --single-branch --branch "dev" https://github.com/vernesong/OpenClash.git
cd OpenClash
cp -r luci-app-openclash /workdir/openwrt/package/
#aliyundrive-webdav
cd /workdir
git clone --depth 1 https://github.com/messense/aliyundrive-webdav.git
cd aliyundrive-webdav/
cp -r openwrt /workdir/openwrt/package/aliyundrive-webdav
#luci-app-zerotier
#cd /workdir
#git clone --depth 1 https://github.com/immortalwrt/luci.git immortalwrt-luci
#cd immortalwrt-luci/applications/
#cp -r luci-app-zerotier /workdir/openwrt/package/
#sed -i 's/include ..\/..\/luci.mk/include $(TOPDIR)\/feeds\/luci\/luci.mk/g' /workdir/openwrt/package/luci-app-zerotier/Makefile


#arpbind & autoreboot
#cd /workdir
#git clone --depth 1 https://github.com/coolsnowwolf/luci.git lede-luci
#cd lede-luci/applications/
#cp -r luci-app-arpbind /workdir/openwrt/package/
#cp -r luci-app-autoreboot /workdir/openwrt/package/
#sed -i 's/include ..\/..\/luci.mk/include $(TOPDIR)\/feeds\/luci\/luci.mk/g' /workdir/openwrt/package/luci-app-arpbind/Makefile
#sed -i 's/include ..\/..\/luci.mk/include $(TOPDIR)\/feeds\/luci\/luci.mk/g' /workdir/openwrt/package/luci-app-autoreboot/Makefile
#sed -i 's/LUCI_DEPENDS:=+luci/LUCI_DEPENDS:=/g' /workdir/openwrt/package/luci-app-autoreboot/Makefile
#mosdns
cd /workdir/openwrt
git clone --depth 1 https://github.com/sbwml/luci-app-mosdns --single-branch -b v5 package/mosdns
#qbittorrent
git clone --depth 1 https://github.com/sbwml/openwrt-qBittorrent package/qBittorrent
#alist
git clone --depth 1 https://github.com/sbwml/luci-app-alist package/alist
#OAF
git clone --depth 1 https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter
#vlmcsd
git clone --depth 1 https://github.com/siwind/openwrt-vlmcsd package/vlmcsd
git clone --depth 1 https://github.com/siwind/luci-app-vlmcsd.git package/luci-app-vlmcsd
#argon
git clone --depth 1 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone --depth 1 https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config
#pushbot
git clone --depth 1 https://github.com/zzsj0928/luci-app-pushbot package/luci-app-pushbot
#去除uhttpd
sed -i 's/+uhttpd-mod-ubus//g' /workdir/openwrt/package/feeds/luci/luci-light/Makefile
sed -i 's/+uhttpd \\//g' /workdir/openwrt/package/feeds/luci/luci-light/Makefile
sed -i 's/+rpcd-mod-rrdns \\/+rpcd-mod-rrdns/g'  /workdir/openwrt/package/feeds/luci/luci-light/Makefile
#替换默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g'  /workdir/openwrt/package/feeds/luci/luci-light/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g'  /workdir/openwrt/package/feeds/luci/luci-nginx/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g'  /workdir/openwrt/package/feeds/luci/luci-ssl-nginx/Makefile

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




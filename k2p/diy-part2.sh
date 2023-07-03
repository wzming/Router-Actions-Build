#!/bin/bash


#sed -i 's/+uhttpd +uhttpd-mod-ubus +luci-mod-admin-full +luci-theme-bootstrap/+luci-mod-admin-full/g' /workdir/openwrt/feeds/luci/collections/luci/Makefile
#sed -i 's/+luci-theme-bootstrap //g' /workdir/openwrt/feeds/luci/collections/luci-nginx/Makefile
#sed -i 's/+luci-theme-bootstrap //g' /workdir/openwrt/feeds/luci/collections/luci-ssl-nginx/Makefile

cd /workdir/openwrt
# 删除老版本watchcat
rm -rf feeds/packages/utils/watchcat
svn co https://github.com/openwrt/packages/trunk/utils/watchcat feeds/packages/utils/watchcat

git clone https://github.com/gngpp/luci-app-watchcat-plus.git package/luci-app-watchcat-plus
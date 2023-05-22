#!/bin/bash


sed -i 's/+uhttpd +uhttpd-mod-ubus +luci-mod-admin-full +luci-theme-bootstrap/+luci-mod-admin-full/g' /workdir/openwrt/feeds/luci/collections/luci/Makefile
sed -i 's/+luci-theme-bootstrap //g' /workdir/openwrt/feeds/luci/collections/luci-nginx/Makefile
sed -i 's/+luci-theme-bootstrap //g' /workdir/openwrt/feeds/luci/collections/luci-ssl-nginx/Makefile
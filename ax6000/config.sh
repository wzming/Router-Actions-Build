#!/bin/bash
git clone --depth 1 -b ax6000 --single-branch $1 /workdir/config
cd /workdir/config
mkdir -p /workdir/openwrt/files
mv etc /workdir/openwrt/files/
mv root /workdir/openwrt/files/
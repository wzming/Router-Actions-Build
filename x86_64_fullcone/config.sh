#!/bin/bash
git clone --depth 1 -b x86_64 --single-branch ${secrets.PULL_SETTING_REPO_URL} /workdir/config
cd /workdir/config
mkdir -p /workdir/openwrt/files
mv etc /workdir/openwrt/files/
mv root /workdir/openwrt/files/
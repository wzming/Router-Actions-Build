#!/bin/bash

#bump kernel
rm -rf include/kernel-5.15
cat >> include/kernel-5.15 << EOF
LINUX_VERSION-5.15 = .133
LINUX_KERNEL_HASH-5.15.133 = ef845e7934897b88e4448378ea9daacac19e07f156fe904844fab0a7d8ff5ddd"
EOF
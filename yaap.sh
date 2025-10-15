#!/bin/bash

# cleanup
rm -rf device/motorola
rm -rf vendor/motorola
rm -rf kernel/motorola
rm -rf hardware/motorola

# Init Rom Manifest
repo init -u https://github.com/yaap/manifest.git -b sixteen --git-lfs

# Sync the repositories  
/opt/crave/resync.sh 

# Add KSU next
cd kernel/motorola/sm6225
curl -LSs "https://raw.githubusercontent.com/rifsxd/KernelSU-Next/next/kernel/setup.sh" | bash -
cd ../../..

# Variables
export BUILD_USERNAME=Himanshu
export BUILD_HOSTNAME=crave

# Set up build environment
source build/envsetup.sh

# Lunch & Build
lunch yaap_device-user && m yaap

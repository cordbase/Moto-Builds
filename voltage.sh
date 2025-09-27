#!/bin/bash

# cleanup
rm -rf device/motorola/devon
rm -rf device/motorola/hawao
rm -rf device/motorola/rhode
rm -rf device/motorola/sm6225-common
rm -rf vendor/motorola/devon
rm -rf vendor/motorola/hawao
rm -rf vendor/motorola/rhode
rm -rf vendor/motorola/sm6225-common
rm -rf kernel/motorola/sm6225
rm -rf hardware/motorola

# Init Rom Manifest
repo init --depth=1 -u https://github.com/VoltageOS/manifest.git -b 16 --git-lfs

# Sync the repositories  
/opt/crave/resync.sh 

# Device trees
git clone --branch voltage-A16 https://github.com/cordbase/device_motorola_devon.git device/motorola/devon
git clone --branch voltage-A16 https://github.com/cordbase/device_motorola_hawao.git device/motorola/hawao
git clone --branch voltage-A16 https://github.com/cordbase/device_motorola_rhode.git device/motorola/rhode
git clone --branch voltage-A16 https://github.com/cordbase/device_motorola_sm6225-common.git device/motorola/sm6225-common

# Vendor trees
git clone https://github.com/TheMuppets/proprietary_vendor_motorola_devon.git vendor/motorola/devon
git clone https://github.com/TheMuppets/proprietary_vendor_motorola_hawao.git vendor/motorola/hawao
git clone https://github.com/TheMuppets/proprietary_vendor_motorola_rhode.git vendor/motorola/rhode
git clone https://github.com/TheMuppets/proprietary_vendor_motorola_sm6225-common.git vendor/motorola/sm6225-common

# Kernel source
git clone --branch lineage-23.0 https://github.com/cordbase/DanceKernel.git kernel/motorola/sm6225

# Hardware dependency
git clone --branch A16 https://github.com/SM6225-Motorola/hardware_motorola.git hardware/motorola

# Add KSU next
cd kernel/motorola/sm6225
curl -LSs "https://raw.githubusercontent.com/rifsxd/KernelSU-Next/next/kernel/setup.sh" | bash -
cd ../../..

# Set up build environment
export BUILD_USERNAME=Himanshu
export BUILD_HOSTNAME=crave

. build/envsetup.sh

export WITH_GMS=true
export TARGET_BOOT_ANIMATION_RES=1080
export WITH_GAPPS=true
export TARGET_ENABLE_BLUR=true
export UCLAMP_FEATURE_ENABLED=true

brunch devon

#!/bin/bash

# Init Rom Manifest
repo init --depth=1 -u https://github.com/VoltageOS/manifest.git -b 16 --git-lfs

# Sync the repositories  
/opt/crave/resync.sh 
# /opt/crave/resynctest.sh

# Device trees
git clone --branch A16 https://github.com/SM6225-Motorola/device_motorola_devon.git device/motorola/devon
git clone --branch A16 https://github.com/SM6225-Motorola/device_motorola_hawao.git device/motorola/hawao
git clone --branch A16 https://github.com/SM6225-Motorola/device_motorola_rhode.git device/motorola/rhode
git clone --branch A16 https://github.com/SM6225-Motorola/device_motorola_sm6225-common.git device/motorola/sm6225-common

# Vendor trees
git clone https://github.com/TheMuppets/proprietary_vendor_motorola_devon.git vendor/motorola/devon
git clone https://github.com/TheMuppets/proprietary_vendor_motorola_hawao.git vendor/motorola/hawao
git clone https://github.com/TheMuppets/proprietary_vendor_motorola_rhode.git vendor/motorola/rhode
git clone https://github.com/TheMuppets/proprietary_vendor_motorola_sm6225-common.git vendor/motorola/sm6225-common

# Kernel source
git clone --branch lineage-23.0 https://github.com/cordbase/DanceKernel.git kernel/motorola/sm6225

# Hardware dependency
git clone --branch A16 https://github.com/SM6225-Motorola/hardware_motorola.git hardware/motorola

# Set up build environment
export BUILD_USERNAME=Himanshu
export BUILD_HOSTNAME=crave

source build/envsetup.sh

export WITH_GMS=true
export TARGET_BOOT_ANIMATION_RES=1080
export WITH_GAPPS=true
export TARGET_ENABLE_BLUR=true
export UCLAMP_FEATURE_ENABLED=true

lunch lineage_rhode-bp1a-userdebug && mka bacon

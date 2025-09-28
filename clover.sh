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
repo init -u https://github.com/The-Clover-Project/manifest.git -b 16 --git-lfs

# Sync the repositories  
/opt/crave/resync.sh 

# Device trees
git clone --branch clover-A16 https://github.com/cordbase/device_motorola_devon.git device/motorola/devon
git clone --branch clover-A16 https://github.com/cordbase/device_motorola_hawao.git device/motorola/hawao
git clone --branch clover-A16 https://github.com/cordbase/device_motorola_rhode.git device/motorola/rhode
git clone --branch A16 https://github.com/cordbase/device_motorola_sm6225-common.git device/motorola/sm6225-common

# Vendor trees
git clone https://github.com/TheMuppets/proprietary_vendor_motorola_devon.git vendor/motorola/devon
git clone https://github.com/TheMuppets/proprietary_vendor_motorola_hawao.git vendor/motorola/hawao
git clone https://github.com/TheMuppets/proprietary_vendor_motorola_rhode.git vendor/motorola/rhode
git clone https://github.com/TheMuppets/proprietary_vendor_motorola_sm6225-common.git vendor/motorola/sm6225-common

# Kernel source
git clone --branch lineage-23.0 https://github.com/cordbase/DanceKernel.git kernel/motorola/sm6225

# Hardware dependency
git clone --branch A16 https://github.com/SM6225-Motorola/hardware_motorola.git hardware/motorola

# MotoCamera (Thanks @Deivid21)
git clone --branch android-15 https://gitlab.com/Deivid21/proprietary_vendor_motorola_MotoSignatureApp.git vendor/motorola/MotoSignatureApp
git clone --branch android-15 https://gitlab.com/Deivid21/proprietary_vendor_motorola_MotorolaSettingsProvider.git vendor/motorola/MotorolaSettingsProvider
git clone --branch android-15 https://gitlab.com/Deivid21/proprietary_vendor_motorola_MotoPhotoEditor.git vendor/motorola/MotoPhotoEditor
git clone --branch android-15 https://gitlab.com/Deivid21/proprietary_vendor_motorola_MotCamera-common.git vendor/motorola/MotCamera-common
git clone --branch android-15 https://gitlab.com/Deivid21/proprietary_vendor_motorola_MotCamera4-bengal.git vendor/motorola/MotCamera4-bengal
git clone --branch android-15 https://gitlab.com/Deivid21/proprietary_vendor_motorola_MotCameraAI-common.git vendor/motorola/MotCameraAI-common
git clone --branch android-15 https://gitlab.com/Deivid21/proprietary_vendor_motorola_MotCamera3AI-bengal.git vendor/motorola/MotCamera3AI-bengal

# Add KSU next
cd kernel/motorola/sm6225
curl -LSs "https://raw.githubusercontent.com/rifsxd/KernelSU-Next/next/kernel/setup.sh" | bash -
cd ../../..

# Variables
export BUILD_USERNAME=Himanshu
export BUILD_HOSTNAME=crave

# Set up build environment
source build/envsetup.sh

# lunch
lunch clover_devon-bp2a-userdebug

# Build
mka clover -j$(nproc --all)

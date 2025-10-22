#!/bin/bash

# cleanup
rm -rf prebuilts/clang/host/linux-x86
rm -rf .repo/local_manifests
rm -rf device/motorola
rm -rf vendor/motorola
rm -rf kernel/motorola
rm -rf hardware/motorola

# Device manifest
mkdir -p .repo/local_manifests
curl -L -o .repo/local_manifests/yaap.xml https://raw.githubusercontent.com/cordbase/local_manifest/moto/yaap.xml

# Init Rom Manifest
repo init -u https://github.com/yaap/manifest.git -b fourteen --git-lfs

# Sync the repositories  
/opt/crave/resync.sh 

# Add KSU next
cd kernel/motorola/sm6225
curl -LSs "https://raw.githubusercontent.com/rifsxd/KernelSU-Next/next/kernel/setup.sh" | bash -
cd ../../..

# set username
git config --global user.name "cordbase"
git config --global user.email "cordbase@users.noreply.github.com"

rm -rf packages/apps/FMRadio

# Set up build environment
source build/envsetup.sh

# Variables
export TZ=Asia/Kolkata
export BUILD_USERNAME=Himanshu
export BUILD_HOSTNAME=crave
export YAAP_BUILDTYPE=HOMEMADE
export TARGET_BUILD_GAPPS=true
export TARGET_ENABLE_BLUR=false

# clean Build
make installclean

# Lunch & Build
lunch yaap_rhode-user && m yaap

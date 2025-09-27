#!/bin/bash

# Init Rom Manifest
repo init --depth=1 -u https://github.com/VoltageOS/manifest.git -b 16 --git-lfs

# Sync the repositories  
/opt/crave/resync.sh 

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

# Add KSU next
cd kernel/motorola/sm6225
curl -LSs "https://raw.githubusercontent.com/rifsxd/KernelSU-Next/next/kernel/setup.sh" | bash -
cd ../../..

# VoltageOS specific Patches
# List of devices
DEVICES=("devon" "rhode" "hawao")

for DEVICE in "${DEVICES[@]}"; do
    DEVICE_PATH="device/motorola/$DEVICE"
    echo "Processing $DEVICE_PATH ..."

    if [ ! -d "$DEVICE_PATH" ]; then
        echo "Device tree $DEVICE_PATH not found. Skipping."
        continue
    fi

    cd "$DEVICE_PATH" || continue

    # Step 1: Rename lineage_<device>.mk to voltage_<device>.mk
    MK_FILE="lineage_${DEVICE}.mk"
    VOLT_FILE="voltage_${DEVICE}.mk"

    if [ -f "$MK_FILE" ]; then
        mv "$MK_FILE" "$VOLT_FILE"
        echo "Renamed $MK_FILE → $VOLT_FILE"
    else
        echo "$MK_FILE not found. Skipping rename."
    fi

    # Step 2: Update AndroidProducts.mk
    if [ -f AndroidProducts.mk ]; then
        sed -i 's/lineage/voltage/g' AndroidProducts.mk
        echo "Updated AndroidProducts.mk for $VOLT_FILE"
    else
        echo "AndroidProducts.mk not found in $DEVICE_PATH. Skipping."
    fi

    # Step 3: Verify
    grep "voltage_${DEVICE}" AndroidProducts.mk >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "$DEVICE successfully updated."
    else
        echo "Warning: voltage_${DEVICE} not found in AndroidProducts.mk"
    fi

    # Go back to ROM root
    cd ../../../
done

echo "All devices processed."

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

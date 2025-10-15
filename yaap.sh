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

# set username
git config --global user.name "cordbase"
git config --global user.email "cordbase@users.noreply.github.com"

# List of patches: "<repo_path>|<commit_sha>|<remote_url>"
PATCHES=(
  "device/motorola/rhode|I68a51d79c02e0d3bb57a6ecff4488f8840461182|https://github.com/Tomoms/android_device_motorola_rhode"
  "device/motorola/hawao|I68a51d79c02e0d3bb57a6ecff4488f8840461182|https://github.com/Tomoms/android_device_motorola_rhode"
  "device/motorola/devon|I68a51d79c02e0d3bb57a6ecff4488f8840461182|https://github.com/Tomoms/android_device_motorola_rhode"
)

echo "[*] Applying all patches automatically..."

for entry in "${PATCHES[@]}"; do
  IFS="|" read -r REPO_PATH COMMIT_SHA REMOTE_URL <<< "$entry"
  echo -e "\n[*] Applying patch $COMMIT_SHA in $REPO_PATH"

  # Clone repo if missing
  if [ ! -d "$REPO_PATH" ]; then
    echo "[*] Path $REPO_PATH not found, cloning..."
    git clone --depth=1 "$REMOTE_URL" "$REPO_PATH"
  fi

  pushd "$REPO_PATH" > /dev/null

  PATCH_URL="$REMOTE_URL/commit/$COMMIT_SHA.patch"

  # Skip if already applied
  if git log --oneline | grep -q "$COMMIT_SHA"; then
    echo "[✔] Skipping $COMMIT_SHA (already applied)."
    popd > /dev/null
    continue
  fi

  echo "[*] Downloading patch from $PATCH_URL"
  if curl -fsSL "$PATCH_URL" | git am -3; then
    echo "[✔] Applied $COMMIT_SHA successfully."
  else
    echo "[!] Conflict detected for $COMMIT_SHA, aborting safely..."
    git am --abort || true
  fi

  popd > /dev/null
done

echo -e "All patches processed!"

# Variables
export BUILD_USERNAME=Himanshu
export BUILD_HOSTNAME=crave

# Set up build environment
source build/envsetup.sh

# clean Build
make installclean

# Lunch & Build
lunch yaap_device-user && m yaap

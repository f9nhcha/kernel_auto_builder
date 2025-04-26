#!/bin/bash

# Usage: ./build.sh <device_codename>

DEVICE_CODENAME=$1
 
if [ -z "$DEVICE_CODENAME" ]; then
    echo "Error: Device codename not provided"
    echo "Usage: ./build.sh <device_codename>"
    exit 1
fi

cd kernel_xiaomi_sm6125

# Export required variables
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_COMPILER_STRING=$(clang --version | head -n 1)
export CCACHE_EXEC=$(which ccache)
export LLVM_IAS=1
export KBUILD_BUILD_HOST="Caelum-Plus-Github-actions-Onelots"

# Configure kernel     
echo "CONFIG_BUILD_ARM64_APPENDED_DTB_IMAGE=y" >> arch/arm64/configs/vendor/laurel_sprout.config
make O=out ARCH=arm64 vendor/trinket-perf_defconfig vendor/laurel_sprout.config vendor/kernelsu.config
yes "" | make O=out ARCH=arm64 olddefconfig

# Build kernel
make -j$(nproc --all) O=out \
    ARCH=arm64 \
    CC="ccache clang" \
    LLVM=1 \
    LLVM_IAS=1 \
    CLANG_TRIPLE=aarch64-linux-gnu- \
    CROSS_COMPILE=aarch64-linux-android- \
    CROSS_COMPILE_ARM32=arm-linux-androideabi-
    
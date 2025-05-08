#!/bin/bash

# Usage: ./build.sh <device_codename>

DEVICE_CODENAME=$1
 
if [ -z "$DEVICE_CODENAME" ]; then
    echo "Error: Device codename not provided"
    echo "Usage: ./build.sh <device_codename>"
    exit 1
fi

cd kernel_oneplus_msm8998

# Export required variables
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_COMPILER_STRING=$(clang --version | head -n 1)
export CCACHE_EXEC=$(which ccache)
export KBUILD_BUILD_HOST="Caelum-Github-actions-Onelots"
export LLVM_IAS=1
export CONFIG_BUILD_ARM64_APPENDED_DTB_IMAGE=y

# Configure kernel     
echo "CONFIG_BUILD_ARM64_APPENDED_DTB_IMAGE=y" >> arch/arm64/configs/lineage_oneplus5_defconfig
make O=out ARCH=arm64 lineage_oneplus5_defconfig vendor/kernelsu.config
yes "" | make O=out ARCH=arm64 olddefconfig

# Build kernel
make -j$(nproc --all) O=out \
    ARCH=arm64 \
    CC="ccache clang" \
    LD=ld.lld \
    AR=llvm-ar \
    NM=llvm-nm \
    LLVM_IAS=1 \
    STRIP=llvm-strip \
    OBJCOPY=llvm-objcopy \
    OBJDUMP=llvm-objdump \
    CLANG_TRIPLE=aarch64-linux-gnu- \
    CROSS_COMPILE=aarch64-linux-android- \
    CROSS_COMPILE_ARM32=arm-linux-androideabi- \
    CROSS_COMPILE_COMPAT=arm-linux-androidkernel-
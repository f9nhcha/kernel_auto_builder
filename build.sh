#!/bin/bash

# Usage: ./build.sh <device_codename>

DEVICE_CODENAME=$1
 
if [ -z "$DEVICE_CODENAME" ]; then
    echo "Error: Device codename not provided"
    echo "Usage: ./build.sh <device_codename>"
    exit 1
fi

cd kernel_oneplus_sm8150

# Export required variables
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_COMPILER_STRING=$(clang --version | head -n 1)
export CCACHE_EXEC=$(which ccache)
export KBUILD_BUILD_HOST="Caelum-Github-actions-Onelots"
export LLVM_IAS=1
echo "CONFIG_BUILD_ARM64_DT_OVERLAY=y" >> lineage_sm8150_defconfig

# Configure kernel     
make O=out ARCH=arm64 lineage_sm8150_defconfig vendor/kernelsu.config
./script/config -e WIL6210 -e MSM_RDBG -e DVB_MPQ -e DVB_MPQ_DEMUX -e TSPP -e MMC_TEST -e QCA_CLD_WLAN -e MSM_11AD -e QCOM_LLCC_PERFMON
./script/config --set-str LOCALVERSION "-✨Caelum-OnePlus-7-gfe5c460c3c4c-dirty"
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

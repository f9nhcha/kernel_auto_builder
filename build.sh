#!/bin/bash
 
 # Usage: ./build.sh <device_codename>
 
 DEVICE_CODENAME=$1
 
 if [ -z "$DEVICE_CODENAME" ]; then
     echo "Error: Device codename not provided"
     echo "Usage: ./build.sh <device_codename>"
     exit 1
 fi
 
cd kernel_google_b1c1
 
 # Export required variables
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_COMPILER_STRING=$(clang --version | head -n 1)
export CCACHE_EXEC=$(which ccache)
export KBUILD_BUILD_HOST="Caelum-Github-actions-Onelots"
 
# Configure kernel
make O=out ARCH=arm64 b1c1_defconfig vendor/kernelsu.config V=1
make O=out ARCH=arm64 olddefconfig
./scripts/config --file out/.config -e CONFIG_BUILD_ARM64_APPENDED_DTB_IMAGE

# Build kernel
make -j$(nproc --all) O=out \
    ARCH=arm64 \
    CC="ccache clang" \
    LLVM=1 \
    LLVM_IAS=1 \
    CLANG_TRIPLE=aarch64-linux-gnu- \
    CROSS_COMPILE=aarch64-linux-android- \
    CROSS_COMPILE_ARM32=arm-linux-androideabi-
#!/bin/bash

CLANG=~/clang/bin
GCC32=~/arm-linux-androideabi-4.9/bin
GCC64=~/aarch64-linux-android-4.9/bin
export PATH=$CLANG:$GCC64:$GCC32:$PATH
export ARCH=arm64
export CLANG_TRIPLE=aarch64-linux-gnu
export CROSS_COMPILE=aarch64-linux-android-
export CROSS_COMPILE_ARM32=arm-linux-androideabi-
output_dir=out

start_time=$(date +%s) # 记录开始时间

cd ~/tosasitillKernel_polaris

make O="$output_dir" \
    vendor/xiaomi/mi845_defconfig \
    vendor/xiaomi/polaris.config

make -j$(nproc) \
    O="$output_dir" \
    CC=clang

cd -

cp -v ~/tosasitillKernel_polaris/out/arch/arm64/boot/Image.gz-dtb AnyKernel3/

end_time=$(date +%s) # 记录结束时间
total_time=$((end_time - start_time)) # 计算总计编译时间

echo "总计编译时间为: $((total_time / 60)) 分钟 $((total_time % 60)) 秒"

echo "本次编译内核版本号 ："
read name
echo "                          "
echo "您输入的版本号为:$name,请确认无误"

cd ~/AnyKernel3

7z a -mx9 ../tosasitillKernel-Ci-V$name.zip *



echo "本次编译已完成,共耗时:$((total_time / 60)) 分钟 $((total_time % 60)) 秒,Anykernel文件已拷贝至桌面."

cd ~/tosasitillKernel_polaris

echo "开始清理文件"

make mrproper
make clean

echo "清理完成!可关闭窗口"

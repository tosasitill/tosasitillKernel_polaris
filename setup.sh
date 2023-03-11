#!/bin/bash
echo "Setup ENV"
sudo apt update -y
sudo apt-get install -y bc bison build-essential ccache curl flex g++-multilib gcc-multilib git gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev libelf-dev liblz4-tool libncurses5 libncurses5-dev libsdl1.2-dev libssl-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev
sudo apt clean

echo "Clone NEEDED Files"
git clone https://github.com/tosasitill/tosasitillKernel_polaris --depth=1 -b ONLINE android_kernel_xiaomi_sdm845_LineageOS
s
echo "Patch KernelSU"
cd android_kernel_xiaomi_sdm845_LineageOS
git submodule add https://github.com/tiann/KernelSU

ln -s ~/android_kernel_xiaomi_sdm845_LineageOS/KernelSU/kernel ~/android_kernel_xiaomi_sdm845_LineageOS/drivers

mv ~/android_kernel_xiaomi_sdm845_LineageOS/drivers/kernel ~/android_kernel_xiaomi_sdm845_LineageOS/drivers/kernelsu

cd

cd ~/android_kernel_xiaomi_sdm845_LineageOS/KernelSU
wget https://github.com/ookiineko/KernelSU/commit/0950fbba5e79820da539054f6eb6d1d48ec96ff4.patch
patch -p1 < 0950fbba5e79820da539054f6eb6d1d48ec96ff4.patch
wget https://github.com/tiann/KernelSU/commit/8fbdd996de69abd107f147218881ae1aa72ef565.patch
patch -p1 -R < 8fbdd996de69abd107f147218881ae1aa72ef565.patch
rm -rf *.patch
echo "Build Kernel"
start_time=$(date +%s) # 记录开始时间
cd
cd android_kernel_xiaomi_sdm845_LineageOS
bash ./build_online.sh

echo "CPU 信息："
cat /proc/cpuinfo | grep 'model name' | uniq
cat /proc/cpuinfo | grep 'cpu MHz' | uniq
echo "内存信息："
free -m
echo "磁盘空间信息："
df -h
echo "操作系统信息："


# 将系统信息保存到 info.txt 文件中
echo "CPU 信息：" >> INFO.txt
cat /proc/cpuinfo | grep 'model name' | uniq >> INFO.txt
cat /proc/cpuinfo | grep 'cpu MHz' | uniq >> INFO.txt
echo "内存信息：" >> INFO.txt
free -m >> INFO.txt
echo "磁盘空间信息：" >> INFO.txt
df -h >> INFO.txt
echo "操作系统信息：" >> INFO.txt

end_time=$(date +%s) # 记录结束时间
total_time=$((end_time - start_time)) # 计算总计编译时间
          

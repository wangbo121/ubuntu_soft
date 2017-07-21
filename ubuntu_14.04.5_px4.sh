#!/bin/bash
# Info   : install tools on ubuntu 64bit 14.04.5 for px4
# Author : wangbo                            
# CTime  : 2017.07.20 

#---------使用命令:sudo chmod a+x ubuntu_14.04.5_px4.sh-----------------
#---------执行安装脚本程序命令为: sh ubuntu_14.04.5_px4 或者 ./ubuntu_14.04.5_px4 ---------------------
#-------------------------------------------

#ubuntu由于使用了/bin/sh 导致找不到pushd命令
#切换回/bin/bash即可，但是我在shell中声明#!/bin/bash还是继续报错
sudo cp /bin/sh /bin/sh_backup
sudo rm -f /bin/sh
sudo ln -s /bin/bash /bin/sh

#设置github用户名，这个每个人需要修改
GIT_NAME=wangbo121
GIT_EMAIL=wangbo121@189.cn

echo -e "Install ubuntu_14.04.5_px4.sh Start\n\n"
echo "*************************************"
#设置用户名
USER_NAME=$USER

#更改镜像源
UBUNTU_VERSION=trusty
SOURCES_LIST=/etc/apt/sources.list

#备份旧的镜像源
sudo cp /etc/apt/sources.list /etc/apt/sources.list_backup_$(date +%s)
sudo rm $SOURCES_LIST
sudo touch $SOURCES_LIST
sudo chmod a+w $SOURCES_LIST
sudo chmod a+r $SOURCES_LIST

#SOURCE_ADDRESS=http://cn.archive.ubuntu.com/
#sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION           main restricted universe multiverse" >> $SOURCES_LIST
#sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-security  main restricted universe multiverse" >> $SOURCES_LIST
#sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-updates   main restricted universe multiverse" >> $SOURCES_LIST
#sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-proposed  main restricted universe multiverse" >> $SOURCES_LIST
#sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-backports main restricted universe multiverse" >> $SOURCES_LIST

SOURCE_ADDRESS=http://mirror.bit.edu.cn
sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION           main restricted universe multiverse" >> $SOURCES_LIST
sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-security  main restricted universe multiverse" >> $SOURCES_LIST
sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-updates   main restricted universe multiverse" >> $SOURCES_LIST
sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-proposed  main restricted universe multiverse" >> $SOURCES_LIST
sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-backports main restricted universe multiverse" >> $SOURCES_LIST

#SOURCE_ADDRESS=http://mirrors.aliyun.com
#sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION           main restricted universe multiverse" >> $SOURCES_LIST
#sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-security  main restricted universe multiverse" >> $SOURCES_LIST
#sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-updates   main restricted universe multiverse" >> $SOURCES_LIST
#sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-proposed  main restricted universe multiverse" >> $SOURCES_LIST
#sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-backports main restricted universe multiverse" >> $SOURCES_LIST

#SOURCE_ADDRESS=http://mirrors.163.com
#sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION           main restricted universe multiverse" >> $SOURCES_LIST
#sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-security  main restricted universe multiverse" >> $SOURCES_LIST
#sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-updates   main restricted universe multiverse" >> $SOURCES_LIST
#sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-proposed  main restricted universe multiverse" >> $SOURCES_LIST
#sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-backports main restricted universe multiverse" >> $SOURCES_LIST

# 删除  
sudo rm -fR /var/lib/apt/lists/*  
# 新建相应文件夹  
sudo mkdir /var/lib/apt/lists/partial
sudo apt-get clean 
#更新镜像源
#sudo apt-get update
sudo apt-get update --fix-missing 

#安装vim代替vi
echo -e "Start install vim\n\n"
sudo apt-get install vim -y
sudo apt-get autoremove -y

#安装编译工具 gcc g++ make等等
echo -e "Start install gcc g++\n\n"
sudo apt-get install gcc g++ -y
sudo apt-get autoremove -y
sudo apt-get install build-essential -y
sudo apt-get autoremove -y

#安装ssh服务器
echo -e "Start install ssh\n\n"
sudo apt-get install openssh-server -y

#安装samba服务器
echo -e "Start install samba\n\n"
sudo apt-get install samba -y
sudo apt-get autoremove -y

#-------------------------------------------
#---------     编译PX4相关软件     ---------------------
#-------------------------------------------
#安装git
sudo apt-get install git git-core  -y
sudo apt-get autoremove -y

#添加wangbo这个用户到dialout组
sudo usermod -a -G dialout $USER_NAME

#安装Ninja编译系统，编译速度比make更快，如果安装了Ninja，编译时会自动选择这个工具
echo -e "Start install Ninja\n\n"
sudo add-apt-repository ppa:george-edison55/cmake-3.x -y
sudo apt-get update
sudo apt-get install python-argparse git-core wget zip python-empy qtcreator cmake build-essential genromfs -y
#couldn't find python module jinja2
sudo apt-get install python-jinja2 -y
sudo apt-get autoremove -y

#安装仿真工具simulation tools
echo -e "Start install simulation tools\n\n"
#sudo apt-get install ant protobuf-compiler libeigen3-dev libopencv-dev openjdk-8-jdk openjdk-8-jre clang-3.5 lldb-3.5 -y
sudo apt-get install ant protobuf-compiler libeigen3-dev libopencv-dev clang-3.5 lldb-3.5 -y
sudo apt-get autoremove -y
#官网的安装命令中openjdk-8-jdk openjdk-8-jre在Ubuntu14.10可以直接安装，但是在14.04.5不能直接安装，我的版本是14.04.5x64
#安装jdk，ubuntu16.04.5可以直接apt安装
#echo -e "Start install openjdk-8-jdk jre\n\n"
#sudo apt-get install openjdk-8-jdk openjdk-8-jre -y
#安装jdk 如果不可以直接通过apt-get安装那么执行下列命令
sudo add-apt-repository ppa:openjdk-r/ppa -y
sudo apt-get update 
sudo apt-get install openjdk-8-jdk openjdk-8-jre -y
sudo apt-get autoremove -y

#删除掉Ubuntu自带的串口管理模块
sudo apt-get remove modemmanager -y
sudo apt-get autoremove -y

#删除ubuntu14.04.5本身自带的arm-none-eabi-gcc
sudo apt-get remove gcc-arm-none-eabi gdb-arm-none-eabi binutils-arm-none-eabi -y
sudo apt-get autoremove -y

sudo apt-get install python-serial openocd \
    flex bison libncurses5-dev autoconf texinfo build-essential \
    libftdi-dev libtool zlib1g-dev \
    python-empy -y
sudo apt-get autoremove -y

#gcc 4.8.4 已经过时了，目前支持的是 4.9.4还有 5.4.3版本。
#pushd .
#cd ~
#wget https://launchpad.net/gcc-arm-embedded/5.0/5-2016-q2-update/+download/gcc-arm-none-eabi-5_4-2016q2-20160622-linux.tar.bz2
#tar -jxf gcc-arm-none-eabi-5_4-2016q2-20160622-linux.tar.bz2
#exportline="export PATH=$HOME/gcc-arm-none-eabi-5_4-2016q2/bin:$PATH"
#if grep -Fxq "$exportline" ~/.profile; then echo nothing to do ; else echo $exportline >> ~/.profile; fi
#. ~/.profile
#popd

#用wget下载速度太慢，先下载好再解压缩
tar -jxf gcc-arm-none-eabi-5_4-2016q2-20160622-linux.tar.bz2
exportline="export PATH=$HOME/gcc-arm-none-eabi-5_4-2016q2/bin:$PATH"
if grep -Fxq "$exportline" ~/.profile; then echo nothing to do ; else echo $exportline >> ~/.profile; fi
. ~/.profile

#因为安装的是64位的Ubuntu，所以还需要安装下面的lsb-core，否则报错
sudo apt-get install lsb-core -y
sudo apt-get autoremove -y
arm-none-eabi-gcc --version
echo -e "Finish install gcc-arm-none-eabi"

#配置git，然后下载px4的Firmware，编译##########
#配置用户名  
git config --global user.name "$GIT_NAME"
# 配置邮件  
git config --global user.email "$GIT_EMAIL"
#解决git clone下载速度慢问题
sudo cp /etc/ssh/ssh_config /etc/ssh/ssh_config_backup_$(date +%s)
sudo sed 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/' -i /etc/ssh/ssh_config

cd ~
mkdir -p ~/src
cd ~/src
#git clone https://github.com/PX4/Firmware.git
git clone https://github.com/fb-vtol/Firmware.git
cd Firmware
git submodule update --init --recursive
cd ../..
#sudo chmod a+w -R src
#sudo chmod a+x -R src

#安装qtcreator
echo -e "Start install qtcreator\n\n"
sudo apt-get install qtcreator -y
sudo apt-get autoremove -y
#配置qtcreator
cd ~/src/Firmware
mkdir ../Firmware-build
cd ../Firmware-build
#cmake ../Firmware -G "CodeBlocks - Unix Makefiles"
cmake ../Firmware -G "CodeBlocks - Unix Makefiles" -DCONFIG=nuttx_px4fmu-v2_default
#接下来是把工程导入到qtcreator中，见http://www.nephen.com/2015/12/env-build-of-px4
#最后把qtcreator快捷方式放到桌面或者在Ubuntu的搜索栏里启动，一定不要使用sudo命令启动qtcreator

echo -e "All SoftWare have been Installed!!! You can just build px4 or ardupilot!!!\n\n"
echo "******************************************\n\n"

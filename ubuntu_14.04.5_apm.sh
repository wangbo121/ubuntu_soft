#!/bin/bash
# Info   : install tools on ubuntu 64bit 14.04.5 for ardupilot
# Author : wangbo                            
# CTime  : 2017.07.120 

#---------使用命令:sudo chmod a+x ubuntu_14.04.5_apm.sh-----------------
#---------执行安装脚本程序命令为: sh ubuntu_14.04.5_apm.sh 或者 ./ubuntu_14.04.5_apm.sh ---------------------
#-------------------------------------------

#ubuntu由于使用了/bin/sh 导致找不到pushd命令
#切换回/bin/bash即可，但是我在shell中声明#!/bin/bash还是继续报错
sudo cp /bin/sh /bin/sh_backup
sudo rm -f /bin/sh
sudo ln -s /bin/bash /bin/sh

#设置github用户名，这个每个人需要修改
GIT_NAME=wangbo121
GIT_EMAIL=wangbo121@189.cn

echo -e "Install ubuntu_1404_apm.sh Start\n\n"
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

SOURCE_ADDRESS=http://cn.archive.ubuntu.com/
sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION           main restricted universe multiverse" >> $SOURCES_LIST
sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-security  main restricted universe multiverse" >> $SOURCES_LIST
sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-updates   main restricted universe multiverse" >> $SOURCES_LIST
sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-proposed  main restricted universe multiverse" >> $SOURCES_LIST
sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-backports main restricted universe multiverse" >> $SOURCES_LIST

SOURCE_ADDRESS=http://mirror.bit.edu.cn
sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION           main restricted universe multiverse" >> $SOURCES_LIST
sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-security  main restricted universe multiverse" >> $SOURCES_LIST
sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-updates   main restricted universe multiverse" >> $SOURCES_LIST
sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-proposed  main restricted universe multiverse" >> $SOURCES_LIST
sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-backports main restricted universe multiverse" >> $SOURCES_LIST

SOURCE_ADDRESS=http://mirrors.aliyun.com
sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION           main restricted universe multiverse" >> $SOURCES_LIST
sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-security  main restricted universe multiverse" >> $SOURCES_LIST
sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-updates   main restricted universe multiverse" >> $SOURCES_LIST
sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-proposed  main restricted universe multiverse" >> $SOURCES_LIST
sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-backports main restricted universe multiverse" >> $SOURCES_LIST

SOURCE_ADDRESS=http://mirrors.163.com
sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION           main restricted universe multiverse" >> $SOURCES_LIST
sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-security  main restricted universe multiverse" >> $SOURCES_LIST
sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-updates   main restricted universe multiverse" >> $SOURCES_LIST
sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-proposed  main restricted universe multiverse" >> $SOURCES_LIST
sudo echo "deb $SOURCE_ADDRESS/ubuntu/ $UBUNTU_VERSION-backports main restricted universe multiverse" >> $SOURCES_LIST

#更新镜像源
sudo apt-get update

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
#echo -e "Start install ssh\n\n"
#sudo apt-get install openssh-server -y

#安装samba服务器
echo -e "Start install samba\n\n"
sudo apt-get install samba -y
sudo apt-get autoremove -y

#-------------------------------------------
#---------     编译apm相关软件     ---------------------
#-------------------------------------------
#安装git
sudo apt-get -qq -y install git
sudo apt-get install git git-core  -y
sudo apt-get autoremove -y

#添加wangbo这个用户到dialout组
sudo usermod -a -G dialout $USER_NAME

#删除ubuntu14.04.5本身自带的arm-none-eabi-gcc
sudo apt-get remove gcc-arm-none-eabi gdb-arm-none-eabi binutils-arm-none-eabi -y
sudo apt-get autoremove -y

sudo apt-get install python-serial openocd \
    flex bison libncurses5-dev autoconf texinfo build-essential \
    libftdi-dev libtool zlib1g-dev \
    python-empy -y
sudo apt-get autoremove -y

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
. ~/.profile

#因为安装的是64位的Ubuntu，所以需要安装下面的lsb-core
sudo apt-get install lsb-core
sudo apt-get autoremove -y
arm-none-eabi-gcc --version
echo -e "Finish install gcc-arm-none-eabi"

#配置用户名  
git config --global user.name "$GIT_NAME"
# 配置邮件  
git config --global user.email "$GIT_EMAIL"
#解决git clone下载速度慢问题
sudo cp /etc/ssh/ssh_config /etc/ssh/ssh_config_backup_$(date +%s)
sudo sed 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/' -i /etc/ssh/ssh_config

cd ~
git clone https://github.com/fb-vtol/ardupilot
cd ardupilot
git submodule update --init --recursive

echo -e "All SoftWare have been Installed!!! You can just build px4 or ardupilot!!!\n\n"
echo "******************************************\n\n"

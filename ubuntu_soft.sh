#!/bin/bash
# Info   : install tools for ubuntu
# Author : wangbo                            
# CTime  : 2016.09.02 

#---------使用命令:sudo chmod +x Ubuntu.sh-----------------
#---------执行安装脚本程序命令为: sh Ubuntu.sh 或者 ./Ubuntu.sh ---------------------
#-------------------------------------------

echo -e "Install Program Start\n\n"
sudo cp /etc/apt/sources.list /etc/apt/sourcesbackup.list
sudo cp sources.list /etc/apt/sources.list
sudo cp apt.conf /etc/apt/apt.conf

#设置更新源，更新系统。
sudo apt-get update
#sudo apt-get dist-upgrade
#sudo apt-get upgrade -y

echo -e "Begining install SoftWare which is always needed!\n\n"
#-------------------------------------------
#---------     删除一些没用的软件       ------------
#--------------------------------------force-yes  -y-------
#sudo apt-get remove totem totem-gstreamer totem-mozilla --force-yes  -y
#sudo apt-get remove rhythmbox evolution bittorrent empathy --force-yes  -y


#-------------------------------------------
#---------     常用软件     ---------------------
#-------------------------------------------
#安装vim代替vi
echo -e "Start install vim\n\n"
sudo apt-get install -y vim
#echo "alias vi=vim " >> ~/.bashrc
#source ~/.bashrc

#重新安装firfox
#sudo apt-get remove firfox
#sudo apt-get -y install firfox

#安装编译工具 gcc g++ make等等
echo -e "Start install gcc g++\n\n"
sudo apt-get -y install gcc g++
sudo apt-get -y install build-essential 
#sudo apt-get -y emacs 

#安装ssh服务器
echo -e "Start install ssh\n\n"
#sudo apt-get install openssh-server

#安装samba服务器
echo -e "Start install samba\n\n"
#sudo apt-get install samba

#-------------------------------------------
#---------     编译PX4相关软件     ---------------------
#-------------------------------------------
#安装git
sudo apt-get -y install git git-core

#添加wangbo这个用户到dialout组
sudo usermod -a -G dialout wangbo
#安装Ninja编译系统，速度比make更快
echo -e "Start install Ninja\n\n"
#Install the Ninja Build System for faster build times than with Make. It will be automatically selected if installed.
sudo add-apt-repository ppa:george-edison55/cmake-3.x -y
sudo apt-get update
#sudo apt-get install python-argparse git-core wget zip python-empy qtcreator cmake build-essential genromfs -y
sudo apt-get -c apt.conf install python-argparse git-core wget zip python-empy qtcreator cmake build-essential genromfs -y
# simulation tools
echo -e "Start install simulation tools\n\n"
#sudo apt-get install ant protobuf-compiler libeigen3-dev libopencv-dev openjdk-8-jdk openjdk-8-jre clang-3.5 lldb-3.5 -y
#官网的安装命令中openjdk-8-jdk openjdk-8-jre在Ubuntu14.10可以直接安装，但是在14.04不能直接安装，我的版本是14.04.5x64
sudo apt-get install ant protobuf-compiler libeigen3-dev libopencv-dev clang-3.5 lldb-3.5 -y
#安装jdk
sudo add-apt-repository ppa:openjdk-r/ppa
sudo apt-get update 
#sudo apt-get install openjdk-8-jdk openjdk-8-jre -y
sudo apt-get -c apt.conf install openjdk-8-jdk openjdk-8-jre -y

#删除掉Ubuntu自带的串口管理模块
sudo apt-get remove modemmanager -y
#安装交叉编译工具，安装完后执行gcc-arm-none-eabi -v测试版本
sudo apt-get remove gcc-arm-none-eabi gdb-arm-none-eabi binutils-arm-none-eabi -y
sudo add-apt-repository ppa:team-gcc-arm-embedded/ppa -y
sudo apt-get update
echo -e "Start install gcc-arm-none-eabi\n\n"
sudo apt-get install python-serial openocd \
    flex bison libncurses5-dev autoconf texinfo build-essential \
    libftdi-dev libtool zlib1g-dev \
    python-empy gcc-arm-embedded -y
    
#配置git，然后下载px4的Firmware，编译
#配置用户名  
git config --global user.name "wangbo121"
# 配置邮件  
git config --global user.email "wangbo121bit@gmail.com"

mkdir -p ~/src
cd ~/src
git clone https://github.com/PX4/Firmware.git
cd Firmware
git submodule update --init --recursive
cd ..

#安装ibus拼音
sudo apt-get install ibus-libpinyin -y

#安装搜狗输入法
#卸载IBUS输入法
#sudo apt-get purge ibus ibus-gtk ibus-gtk3 ibus-pinyin* ibus-sunpinyin ibus-table python-ibus -y
#安装fcitx输入法
#echo -e "Start install fcitx\n\n"
#sudo add-apt-repository ppa:fcitx-team/nightly -y
#sudo apt-get update 
#sudo apt-get install fcitx-sogoupinyin -y


#小巧实用的截图工具,其实ubuntu12.04之后系统已经自带
#sudo apt-get install gnome-screenshot

#-------------------------------------------
#---------     可选择软件     ---------------------
#-------------------------------------------
#安装解码器、flash播放器、java虚拟机、微软字体
#sudo apt-get -y install ubuntu-restricted-extras

#安装音频解码器
#sudo apt-get -y install ffmpeg
#sudo apt-get -y install mplayer-fonts mplayer mplayer-skins

#图像查看
#sudo apt-get -y install f-spot

#rpm包与deb包相互转换工具
#sudo apt-get install alien
#sudo alien ***.rpm,这是将rpm包转换为deb包的方法,其中***为软件包的名字
#命令执行完毕就可以在同一目录下生成一个deb软件包，名称为***.deb，然后双击之即可安装
#将deb包转换为rpm包：   sudo alien -r    ***(包文件名） deb)

#安装svn  
#sudo apt-get -y install subversion

#安装网络端口扫描工具:
#sudo apt-get -y install nmap

#安装网络测速工具
#sudo apt-get -y install iptraf
#如果想要测试网络速度可以使用 sudo iptraf -g

#安装互联网常用工具
#sudo apt-get install filezilla amsn iptux --force-yes  -y
#lwqq依靠Ubuntu预装的pidgin通讯程序运行，基于WebQQ3.0协议。涵盖大部分原版QQ的功能，例如传输文件、表情、讨论组、好友备注、本地聊天记录等等。但神奇的是没有个性签名显示
#sudo add-apt-repository ppa:lainme/pidgin-lwqq
#sudo apt-get update
#sudo apt-get install libpurple0 pidgin-lwqq 

#堪比迅雷——Uget 下载器,支持多线程下载，断点续传等特性，下载速度非常理想。由aria2作后端，安装方法
#sudo apt-get install uget aria2

#gThumb 可以管理图片，也可以编辑
#sudo add-apt-repository ppa:webupd8team/gthumb
#sudo apt-get update
#sudo apt-get install gthumb

#gnome-paint 有点像windows下的画图工具
#sudo apt-get install gnome-paint
#安装的这些工具如果不设置桌面快捷方式的话,都可以在桌面左上角的Dash中通过关键字查找找到

#主题安装工具
#sudo apt-add-repository ppa:s-lagui
#sudo apt-get update
#sudo apt-get install gstyle

#安装rar zip p7zip-full p7zip-rar支持  
#sudo apt-get -y install rar unrar zip unzip p7zip-full p7zip-rar

#安装smplayer视频播放器
#sudo apt-get -y install smplayer

#安装星译词王
#sudo apt-get -y install stardict
echo -e "All SoftWare have been Installed!!!\n\n"

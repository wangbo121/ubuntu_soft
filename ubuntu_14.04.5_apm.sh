#!/bin/bash
# Info   : install tools on ubuntu 64bit 14.04.5 for ardupilot
# Author : wangbo                            
# CTime  : 2017.07.21

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

echo -e "Install ubuntu_14.04.5_apm.sh Start\n\n"
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
#---------     编译apm相关软件     ---------------------
#-------------------------------------------
#安装git
sudo apt-get install git -y 
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
#也写入~/.bashrc这样，每次开启终端后都可以找到arm-none-eabi-gcc
if grep -Fxq "$exportline" ~/.bashrc; then echo nothing to do ; else echo $exportline >> ~/.bashrc; fi
. ~/.bashrc

#因为安装的是64位的Ubuntu，所以需要安装下面的lsb-core
sudo apt-get install lsb-core -y
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

#----------------
#--------------------install-prereqs-ubuntu.sh
#--------------------------------------
OPT="/opt"
BASE_PKGS="build-essential ccache g++ gawk git make wget"
PYTHON_PKGS="future lxml pymavlink MAVProxy"
PX4_PKGS="python-argparse openocd flex bison libncurses5-dev \
          autoconf texinfo libftdi-dev zlib1g-dev \
          zip genromfs python-empy cmake cmake-data"
#ARM_LINUX_PKGS="g++-arm-linux-gnueabihf pkg-config-arm-linux-gnueabihf"
SITL_PKGS="libtool libxml2-dev libxslt1-dev python-dev python-pip python-setuptools python-matplotlib python-serial python-scipy python-opencv python-numpy python-pyparsing realpath"
ASSUME_YES=false

UBUNTU_YEAR="15" # Ubuntu Year were changes append
UBUNTU_MONTH="10" # Ubuntu Month were changes append

version=$(lsb_release -r -s)
yrelease=$(echo "$version" | cut -d. -f1)
mrelease=$(echo "$version" | cut -d. -f2)

if [ "$yrelease" -ge "$UBUNTU_YEAR" ]; then
    if [ "$yrelease" -gt "$UBUNTU_YEAR" ] || [ "$mrelease" -ge "$UBUNTU_MONTH" ]; then
        SITL_PKGS+=" python-wxgtk3.0 libtool-bin"
    else
        SITL_PKGS+=" python-wxgtk2.8"
    fi
fi

MACHINE_TYPE=$(uname -m)
if [ ${MACHINE_TYPE} == 'x86_64' ]; then
    PX4_PKGS+=" libc6-i386"
else
  echo "no extra pkgs for i386"
fi

# GNU Tools for ARM Embedded Processors
# (see https://launchpad.net/gcc-arm-embedded/)
#ARM_ROOT="gcc-arm-none-eabi-4_9-2015q3"
#ARM_TARBALL="$ARM_ROOT-20150921-linux.tar.bz2"
#ARM_TARBALL_URL="http://firmware.ardupilot.org/Tools/PX4-tools/$ARM_TARBALL"

# Ardupilot Tools
ARDUPILOT_TOOLS="Tools/autotest"

function maybe_prompt_user() {
    if $ASSUME_YES; then
        return 0
    else
        read -p "$1"
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            return 0
        else
            return 1
        fi
    fi
}


OPTIND=1  # Reset in case getopts has been used previously in the shell.
while getopts "y" opt; do
    case "$opt" in
        \?)
            exit 1
            ;;
        y)  ASSUME_YES=true
            ;;
    esac
done

if $ASSUME_YES; then
    APT_GET="sudo apt-get -qq --assume-yes"
else
    APT_GET="sudo apt-get"
fi

# possibly grab a newer cmake for older ubuntu releases
read -r UBUNTU_CODENAME <<<$(lsb_release -c -s)
if [ "$UBUNTU_CODENAME" = "precise" ]; then
    sudo add-apt-repository ppa:george-edison55/precise-backports -y
elif [ "$UBUNTU_CODENAME" = "trusty" ]; then
    sudo add-apt-repository ppa:george-edison55/cmake-3.x -y
fi

sudo usermod -a -G dialout $USER

$APT_GET remove modemmanager
$APT_GET update
#$APT_GET install $BASE_PKGS $SITL_PKGS $PX4_PKGS $ARM_LINUX_PKGS
$APT_GET install $BASE_PKGS $SITL_PKGS $PX4_PKGS
sudo pip2 -q install -U $PYTHON_PKGS

#if [ ! -d $OPT/$ARM_ROOT ]; then
#    (
#        cd $OPT;
#        sudo wget $ARM_TARBALL_URL;
#        sudo tar xjf ${ARM_TARBALL};
#        sudo rm ${ARM_TARBALL};
#    )
#fi

SCRIPT_DIR=$(dirname $(realpath ${BASH_SOURCE[0]}))
ARDUPILOT_ROOT=$(realpath "$SCRIPT_DIR/../../")

#exportline="export PATH=$OPT/$ARM_ROOT/bin:\$PATH";
#grep -Fxq "$exportline" ~/.profile 2>/dev/null || {
#    if maybe_prompt_user "Add $OPT/$ARM_ROOT/bin to your PATH [Y/n]?" ; then
#        echo $exportline >> ~/.profile
#        eval $exportline
#    else
#        echo "Skipping adding $OPT/$ARM_ROOT/bin to PATH."
#    fi
#}

exportline2="export PATH=$ARDUPILOT_ROOT/$ARDUPILOT_TOOLS:\$PATH";
grep -Fxq "$exportline2" ~/.profile 2>/dev/null || {
    if maybe_prompt_user "Add $ARDUPILOT_ROOT/$ARDUPILOT_TOOLS to your PATH [Y/n]?" ; then
        echo $exportline2 >> ~/.profile
        eval $exportline2
    else
        echo "Skipping adding $ARDUPILOT_ROOT/$ARDUPILOT_TOOLS to PATH."
    fi
}

apt-cache search arm-none-eabi

(
 cd $ARDUPILOT_ROOT
 git submodule init
 git submodule update
)

echo -e "All SoftWare have been Installed!!! You can just build px4 or ardupilot!!!\n\n"
echo "******************************************\n\n"

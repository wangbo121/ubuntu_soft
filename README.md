# ubuntu_soft
安装Ubuntu14x64后自动安装一些常用软件

注意：
安装之前一定确保下列事情完成
1、确保网络可以连接互联网，否则可能出现cmake等软件的跳过安装，也就无法使用了，最后无法编译px4
2、确保/etc/ssh_config已经修改，否则gti clone时速度会很慢
3、确保在安装完成后，重新配置java
#sudo update-alternatives --config java
Finally check out current Java version by running:
#java –version



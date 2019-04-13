#!/bin/bash
#安装kvm脚本

chmod -R 777 /usr/local/src/
#1、时间时区同步，修改主机名
ntpdate cn.pool.ntp.org
hwclock --systohc
echo "*/30 * * * * root ntpdate -s 3.cn.poop.ntp.org" >> /etc/crontab

sed -i 's|SELINUX=.*|SELINUX=disabled|' /etc/selinux/config
sed -i 's|SELINUXTYPE=.*|#SELINUXTYPE=targeted|' /etc/selinux/config
sed -i 's|SELINUX=.*|SELINUX=disabled|' /etc/sysconfig/selinux 
sed -i 's|SELINUXTYPE=.*|#SELINUXTYPE=targeted|' /etc/sysconfig/selinux
setenforce 0 && systemctl stop firewalld && systemctl disable firewalld 

rm -rf /var/run/yum.pid 
rm -rf /var/run/yum.pid

#2、查看物理机是否支持虚拟化功能,Inter处理器的虚拟技术标志为vmx。AMD为svm。
cat /proc/cpuinfo |grep vmx 
#安装KVM以及相关的依赖软件包
yum -y install epel-release
yum -y groupinstall "Virtualization Host" 
yum -y install virt-{install,viewer,manager}
yum -y groupinstall "Server with GUI"
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.d/99-sysctl.conf 
sysctl -p
sed -i 's|IPADDR|#IPADDR|' /etc/sysconfig/network-scripts/ifcfg-ens33
sed -i 's|NETMASK|#NETMASK|' /etc/sysconfig/network-scripts/ifcfg-ens33
sed -i 's|GATEWAY|#GATEWAY|' /etc/sysconfig/network-scripts/ifcfg-ens33
sed -i 's|DNS1|#DNS1|' /etc/sysconfig/network-scripts/ifcfg-ens33
echo 'BRIDGE=br0' >> /etc/sysconfig/network-scripts/ifcfg-ens33
cat >> /etc/sysconfig/network-scripts/ifcfg-br0 <<EOF
DEVICE="br0"
TYPE=Bridge
BOOTPROTO=static
ONBOOT=yes
IPADDR=192.168.8.21
NETMASK=255.255.255.0
GATEWAY=192.168.8.2
DNS1=202.103.24.68
EOF
reboot
ifconfig br0 |head -2 
virt-manager

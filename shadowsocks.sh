#!/bin/bash
#this is a shadowsocks shell
hostnamectl set-hostname ss_server
yum install -y epel-release git python-setuptools && easy_install pip
pip install git+https://github.com/shadowsocks/shadowsocks.git@master
cat > /etc/shadowsocks.json  << EOF
{
    "server": "0.0.0.0",
    "port_password": {
        "8728": "123456",
        "8729": "123456",
        "8730": "123456",
        "8731": "123456"
    },
    "timeout": 300,
    "method": "aes-256-ctr"
}
EOF
systemctl restart firewalld
firewall-cmd --zone=public --add-port=8728-8731/tcp --permanent
firewall-cmd --reload
ssserver -c /etc/shadowsocks.json -d start
#获取安装信息
get_ip=$(ip a | grep eth0 | grep inet | awk '{print $2}' |sed 's/\/.*//')
shadowsocks_port_pwd=$(sed -n '4,7p' /etc/shadowsocks.json | sed 's/^[ \t]*//g')
shadowsockscipher=$(awk -F \" '/method/ {print $4}' /etc/shadowsocks.json)
echo " " > ss_info.txt
echo "##############################################################"
echo -e "Shadowsocks server install completed!" >> ss_info.txt
echo " " >> ss_info.txt
echo -e "Your server ip： \n$get_ip" >> ss_info.txt
echo " " >> ss_info.txt
echo -e "Your Server Port and password：\n$shadowsocks_port_pwd" >> ss_info.txt
echo " " >> ss_info.txt
echo -e "Your Encryption Method: \n$shadowsockscipher" >> ss_info.txt
cat ss_info.txt
echo
echo -e 'see this info again run the follow command \n# cat ss_info.txt'
echo
echo "##############################################################"
ssserver -c /etc/shadowsocks.json -d status




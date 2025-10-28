#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
clear
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
tyblue='\e[1;36m'
NC='\e[0m'
purple() { echo -e "\\033[35;1m${*}\\033[0m"; }
tyblue() { echo -e "\\033[36;1m${*}\\033[0m"; }
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
cd /root
#System version number
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi

localip=$(hostname -I | cut -d\  -f1)
hst=( `hostname` )
dart=$(cat /etc/hosts | grep -w `hostname` | awk '{print $2}')
if [[ "$hst" != "$dart" ]]; then
echo "$localip $(hostname)" >> /etc/hosts
fi
mkdir -p /etc/xray

clear
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
echo -e "---------------------------------"
echo -e ""
echo -e " Silahkan Hubungi Admin Untuk Login "
echo -e ""
echo -e " Silahkan Order License "
echo -e ""
echo -e " WhatsApp : 082117696800 "
echo -e ""
echo -e "---------------------------------"
echo ""
read -p "Masukan License : " license
if [ $license = "FREE" ];
then
sleep 2
clear
echo -e "${purple}-----------------------------------${NC}"
echo -e "${green} LICENSE BENAR ${NC}"
echo -e "${purple}-----------------------------------${NC}"
echo -e " Silahkan Tunggu Proses Penginstalan "
echo -e "${purple}-----------------------------------${NC}"
sleep 3
else
clear
echo -e "${purple}-----------------------------------${NC}"
echo -e "${red} LICENSE SALAH ${NC}"
echo -e "${purple}-----------------------------------${NC}"
echo -e " Anda Akan Keluar Dalam 5 Detik"
echo -e "${purple}-----------------------------------${NC}"
sleep 5
clear
rm setup.sh
exit
fi

secs_to_human() {
    echo "Installation time : $(( ${1} / 3600 )) hours $(( (${1} / 60) % 60 )) minute's $(( ${1} % 60 )) seconds"
}
start=$(date +%s)
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null 2>&1
sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null 2>&1

coreselect=''
cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
clear
END
chmod 644 /root/.profile

echo -e "[ ${green}INFO${NC} ] Mempersiapkan Script Penginstalan "
apt install git curl -y >/dev/null 2>&1
echo -e "[ ${green}INFO${NC} ] Script Sudah Ready"
sleep 2
echo -ne "[ ${green}INFO${NC} ] Silahkan Tunggu...."
sleep 3
mkdir -p /etc/dendikusnandi
mkdir -p /etc/dendikusnandi/theme
mkdir -p /var/lib/dendikusnandi-pro >/dev/null 2>&1
echo "IP=" >> /var/lib/dendikusnandi-pro/ipvps.conf

if [ -f "/etc/xray/domain" ]; then
echo ""
echo -e "[ ${green}INFO${NC} ] Script Sudah Terinstall "
echo -ne "[ ${yell}WARNING${NC} ] Apakah Anda Yakin Mau Menginstal Ulang  ? (y/n)? "
read answer
if [ "$answer" == "${answer#[Yy]}" ] ;then
rm setup.sh
sleep 10
exit 0
else
clear
fi
fi

echo ""
wget -q https://raw.githubusercontent.com/dendikusnandi/iLoveU/main/FILE/dependencies.sh;chmod +x dependencies.sh;./dependencies.sh
rm dependencies.sh
clear

read -rp "Masukan Domain : " -e pp
echo "$pp" > /root/domain
echo "$pp" > /root/scdomain
echo "$pp" > /etc/xray/domain
echo "$pp" > /etc/xray/scdomain
echo "IP=$pp" > /var/lib/dendikusnandi-pro/ipvps.conf

#THEME RED
cat <<EOF>> /etc/dendikusnandi/theme/red
BG : \E[40;1;41m
TEXT : \033[0;31m
EOF
#THEME BLUE
cat <<EOF>> /etc/dendikusnandi/theme/blue
BG : \E[40;1;44m
TEXT : \033[0;34m
EOF
#THEME GREEN
cat <<EOF>> /etc/dendikusnandi/theme/green
BG : \E[40;1;42m
TEXT : \033[0;32m
EOF
#THEME YELLOW
cat <<EOF>> /etc/dendikusnandi/theme/yellow
BG : \E[40;1;43m
TEXT : \033[0;33m
EOF
#THEME MAGENTA
cat <<EOF>> /etc/dendikusnandi/theme/magenta
BG : \E[40;1;43m
TEXT : \033[0;33m
EOF
#THEME CYAN
cat <<EOF>> /etc/dendikusnandi/theme/cyan
BG : \E[40;1;46m
TEXT : \033[0;36m
EOF
#THEME CONFIG
cat <<EOF>> /etc/dendikusnandi/theme/color.conf
blue
EOF
    
#install ssh ovpn
echo -e "${purple}-----------------------------------${NC}"
echo -e "${green} PORSES PENGINSTALAN SSH & OPENVPN ${NC}"
echo -e "${purple}-----------------------------------${NC}"
sleep 2
clear
wget https://raw.githubusercontent.com/dendikusnandi/iLoveU/main/FILE/SSH/ssh-vpn.sh && chmod +x ssh-vpn.sh && ./ssh-vpn.sh
#Install Xray
clear
echo -e "${purple}--------------------------${NC}"
echo -e "${green} PORSES PENGINSTALAN XRAY ${NC}"
echo -e "${purple}--------------------------${NC}"
sleep 2
clear
wget https://raw.githubusercontent.com/dendikusnandi/iLoveU/main/FILE/XRAY/ins-xray.sh && chmod +x ins-xray.sh && ./ins-xray.sh
#Install OHP Websocket
clear
echo -e "${purple}-----------------------------------${NC}"
echo -e "${green} PROSES PENGINSTALAN OHP WEBSOCKET ${NC}"
echo -e "${purple}-----------------------------------${NC}"
sleep 2
clear
wget https://raw.githubusercontent.com/dendikusnandi/iLoveU/main/FILE/WEBSOCKET/insshws.sh && chmod +x insshws.sh && ./insshws.sh
#Install AutoBackup
clear
echo -e "${purple}---------------------------------${NC}"
echo -e "${green} PORSES PENGINSTALAN AUTO BACKUP ${NC}"
echo -e "${purple}---------------------------------${NC}"
sleep 2
clear
wget https://raw.githubusercontent.com/dendikusnandi/iLoveU/main/backups/set-br.sh && chmod +x set-br.sh && ./set-br.sh
#Download Extra Menu
clear
echo -e "${purple}------------------------------${NC}"
echo -e "${green} PORSES MENDOWNLOAD XTRA MENU ${NC}"
echo -e "${purple}------------------------------${NC}"
sleep 2
wget https://raw.githubusercontent.com/dendikusnandi/iLoveU/main/FILE/MENU/update.sh && chmod +x update.sh && ./update.sh
clear
cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
clear
menu
END
chmod 644 /root/.profile

if [ -f "/root/log-install.txt" ]; then
rm /root/log-install.txt > /dev/null 2>&1
fi
if [ -f "/etc/afak.conf" ]; then
rm /etc/afak.conf > /dev/null 2>&1
fi
if [ ! -f "/etc/log-create-user.log" ]; then
echo "Log All Account " > /etc/log-create-user.log
fi
history -c
serverV=$( curl -sS https://raw.githubusercontent.com/dendikusnandi/iLoveU/main/FILE/version  )
echo $serverV > /opt/.ver
aureb=$(cat /home/re_otm)
b=11
if [ $aureb -gt $b ]
then
gg="PM"
else
gg="AM"
fi
curl -sS ifconfig.me > /etc/myipvps

echo " "
echo "Installation has been completed!!"
echo " "
echo "=========================[SCRIPT PREMIUM]========================"
echo ""  | tee -a log-install.txt
echo "   >>> Service & Port"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "    [INFORMASI SSH ]" | tee -a log-install.txt
echo "    -------------------------" | tee -a log-install.txt
echo "   - OpenSSH                 : 22"  | tee -a log-install.txt
echo "   - Stunnel4                : 447, 777"  | tee -a log-install.txt
echo "   - Dropbear                : 109, 143"  | tee -a log-install.txt
echo "   - SSH Websocket           : 80"  | tee -a log-install.txt
echo "   - SSH SSL Websocket       : 443"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "    [INFORMASI  Badvpn, Nginx]" | tee -a log-install.txt
echo "    ---------------------------" | tee -a log-install.txt
echo "   - Badvpn                  : 7100-7900"  | tee -a log-install.txt
echo "   - Nginx                   : 81"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "    [INFORMASI Shadowsocks-R & Shadowsocks]"  | tee -a log-install.txt
echo "    ---------------------------------------" | tee -a log-install.txt
echo "   - Websocket Shadowsocks   : 443"  | tee -a log-install.txt
echo "   - Shadowsocks GRPC        : 443"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "    [INFORMASI XRAY]"  | tee -a log-install.txt
echo "    ----------------" | tee -a log-install.txt
echo "   - Xray Vmess Ws Tls       : 443"  | tee -a log-install.txt
echo "   - Xray Vless Ws Tls       : 443"  | tee -a log-install.txt
echo "   - Xray Vmess Ws None Tls  : 80"  | tee -a log-install.txt
echo "   - Xray Vless Ws None Tls  : 80"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "    [INFORMASI TROJAN]"  | tee -a log-install.txt
echo "    ------------------" | tee -a log-install.txt
echo "   - Websocket Trojan        : 443"  | tee -a log-install.txt
echo "   - Trojan GRPC             : 443"  | tee -a log-install.txt
echo "   --------------------------------------------------------------" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Server Information & Other Features"  | tee -a log-install.txt
echo "   - Timezone                : Asia/Jakarta (GMT +7)"  | tee -a log-install.txt
echo "   - Fail2Ban                : [ON]"  | tee -a log-install.txt
echo "   - Dflate                  : [ON]"  | tee -a log-install.txt
echo "   - IPtables                : [ON]"  | tee -a log-install.txt
echo "   - Auto-Reboot             : [ON]"  | tee -a log-install.txt
echo "   - IPv6                    : [OFF]"  | tee -a log-install.txt
echo "   - Auto Reboot On           : $aureb:00 $gg GMT +7" | tee -a log-install.txt
echo "   - Custom Path " | tee -a log-install.txt
echo "   - Auto Backup Data" | tee -a log-install.txt
echo "   - AutoKill Multi Login User" | tee -a log-install.txt
echo "   - Auto Delete Expired Account" | tee -a log-install.txt
echo "   - Fully Automatic Script" | tee -a log-install.txt
echo "   - VPS Settings" | tee -a log-install.txt
echo "   - Admin Control" | tee -a log-install.txt
echo "   - Backup & Restore Data" | tee -a log-install.txt
echo "   - Full Orders For Various Services" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "=========================[SCRIPT PREMIUM]========================"
echo ""
sleep 3
echo -e "    ${tyblue}.------------------------------------------.${NC}"
echo -e "    ${tyblue}|     SUCCESFULLY INSTALLED THE SCRIPT     |${NC}"
echo -e "    ${tyblue}'------------------------------------------'${NC}"
echo ""
echo -e "   ${tyblue}Your VPS Will Be Automatical Reboot In 10 seconds${NC}"
rm /root/cf.sh >/dev/null 2>&1
rm /root/setup.sh >/dev/null 2>&1
rm /root/insshws.sh 
rm /root/update.sh
sleep 10
reboot

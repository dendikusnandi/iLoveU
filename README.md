
### Service & Port:
  Service Port
 - OpenSSH                 : 22
 - Stunnel4                : 447,777
 - Dropbear                : 109,143
 - SSH WS                  : 80
 - SSH WS TLS              : 443
 - BadVPN                  : 7100-7900
 - Shadowsocks Ws + gRPC   : 443
 - XRAY  Vmess TLS + gRPC  : 443
 - XRAY  Vless TLS + gRPC  : 443
 - Trojan WS + gRPC        : 443
 - XRAY  Vmess None TLS    : 80
 - XRAY  Vless None TLS    : 80
 - Nginx                   : 81

### Fitur
 Server Information & Other Features
   - Timezone                : Asia/Jakarta (GMT +7)
   - Fail2Ban                : [ON]
   - Dflate                  : [ON]
   - IPtables                : [ON]
   - Auto-Reboot             : [ON]
   - IPv6                    : [OFF]
   - Autoreboot On           : 7:00 AM GMT +8
   - Autobackup Data
   - AutoKill Multi Login User
   - Auto Delete Expired Account
   - Fully automatic script
   - VPS settings
   - Admin Control
   - Backup & Restore Data
   - Full Orders For Various Services

### Other Services:
Speedtest CLI

### Syarat VPS
- Debian 10 Only
- Virtualization: KVM or HyperV
- Architecture: Intel or AMD
- Wajib Root

### Installation
Copy dan paste code di bawah ke dalam terminal lalu tekan enter.

Update Repo Debian 10

  ```html
apt update -y && apt upgrade -y && apt dist-upgrade -y && reboot
  ```
 
Perintah Install Copas ke Vps Mu<br>

  ```html
sysctl -w net.ipv6.conf.all.disable_ipv6=1 && sysctl -w net.ipv6.conf.default.disable_ipv6=1 && apt update && apt install -y bzip2 gzip coreutils screen curl unzip && wget http://install.yudhy.net/setup.sh && chmod +x setup.sh && sed -i -e 's/\r$//' setup.sh && screen -S setup ./setup.sh
```

### Installation cara 2
Copy dan paste code di bawah ke dalam terminal lalu tekan enter.

**Link Copy script :**

```
apt --fix-missing update && apt update && apt upgrade -y && apt install -y wget screen && wget -q http://install.yudhy.net/setup.sh && chmod +x setup.sh && screen -S setup ./setup.sh
```





### Register IP Pm
Telegram : 
### https://t.me/yudhydm

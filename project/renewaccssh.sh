#!/bin/bash

# Valid Script
ipsaya=$(curl -sS ipv4.icanhazip.com)
data_server=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
date_list=$(date +"%Y-%m-%d" -d "$data_server")


    
# colors
red="\e[91m"
green="\e[92m"
yellow="\e[93m"
blue="\e[94m"
purple="\e[95m"
cyan="\e[96m"
white="\e[97m"
reset="\e[0m"

# variables
domain=$(cat /etc/xray/domain 2>/dev/null || hostname -f)
clear
echo -e "${green}┌─────────────────────────────────────────┐${reset}"
echo -e "${green}│        UPDATE SSH/OVPN ACCOUNT          │${reset}"
echo -e "${green}└─────────────────────────────────────────┘${reset}"

account_count=$(grep -c -E "^### " "/etc/ssh/.ssh.db")
if [[ ${account_count} == '0' ]]; then
    echo ""
    echo "  No customer names available"
    echo ""
    exit 0
fi

# Prompt for username directly
read -rp "Enter username: " user

# Check if user exists
if ! grep -qE "^### $user " "/etc/ssh/.ssh.db"; then
    echo ""
    echo "Username not found"
    echo ""
    exit 1
fi

# Get current expiration date
exp=$(grep -E "^### $user " "/etc/ssh/.ssh.db" | cut -d ' ' -f 3)

clear
echo -e "${yellow}Updating SSH account $user${reset}"
echo ""

# Read expiration date from database
old_exp=$(grep -E "^### $user " "/etc/ssh/.ssh.db" | cut -d ' ' -f 3)

# Calculate remaining active days
days_left=$((($(date -d "$old_exp" +%s) - $(date +%s)) / 86400))

echo "Remaining active days: $days_left days"

while true; do
    read -p "Add active days: " active_days
    if [[ "$active_days" =~ ^[0-9]+$ ]]; then
        break
    else
        echo "Input must be a positive number."
    fi
done

while true; do
    read -p "Device limit (IP): " ip_limit
    if [[ "$ip_limit" =~ ^[1-9][0-9]*$ ]]; then
        break
    else
        echo "Input must be a positive number greater than 0."
    fi
done

if [ ! -d /etc/ssh ]; then
    mkdir -p /etc/ssh
fi

# Hitung tanggal baru DULU, sebelum menyentuh data apa pun.
new_exp=$(date -d "$old_exp +${active_days} days" +"%Y-%m-%d")
if [[ -z "$new_exp" ]]; then
    echo "Gagal menghitung tanggal expiry baru. Perpanjangan dibatalkan."
    exit 1
fi

# Terapkan ke sistem lebih dulu: kalau chage gagal, .ssh.db belum diubah
# sehingga data lama masih utuh. Dulu urutannya kebalikan (sed -i hapus
# baris dulu), jadi kegagalan di tengah menghilangkan entri akun.
if ! chage -E "$new_exp" "$user" 2>/dev/null; then
    echo "Gagal memperbarui masa aktif di sistem. Perpanjangan dibatalkan."
    exit 1
fi

# Tulis .ssh.db lewat file sementara + mv (atomik), bukan hapus-lalu-tambah.
tmp_db=$(mktemp /etc/ssh/.ssh.db.XXXXXX) || { echo "Gagal membuat file sementara."; exit 1; }
grep -v "^### $user " /etc/ssh/.ssh.db >"$tmp_db" 2>/dev/null
echo "### ${user} ${new_exp}" >>"$tmp_db"
chmod --reference=/etc/ssh/.ssh.db "$tmp_db" 2>/dev/null
mv -f "$tmp_db" /etc/ssh/.ssh.db

echo "${ip_limit}" >/etc/ssh/${user}

clear
echo -e "${green}┌─────────────────────────────────────────┐${reset}"
echo -e "${green}│   SSH ACCOUNT UPDATED SUCCESSFULLY      │${reset}"
echo -e "${green}└─────────────────────────────────────────┘${reset}"
echo -e "Username     : ${green}$user${reset}"
echo -e "IP limit     : ${yellow}$ip_limit devices${reset}"
echo -e "Expiration   : ${yellow}$(date -d "$new_exp" "+%d %b %Y")${reset}"
echo ""
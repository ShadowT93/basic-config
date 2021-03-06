#!/bin/bash


# --------------- FTP -----------------------
mkdir /etc/ssl/certificates;
openssl req -x509 -nodes -days 356 -newkey rsa:2048 -keyout /etc/ssl/certificates/vsftpd.pem -out /etc/ssl/certificates/vsftpd.pem;
sed -i  "s/anonymous_enable=YES/anonymous_enable=NO/gI" /etc/vsftpd.conf;
sed -i  "s/write_enable=YES/write_enable=NO/gI" /etc/vsftpd.conf;
sed -i "s|rsa_cert_file=.*|rsa_cert_file=/etc/ssl/certificates/vsftpd.pem|gI" /etc/vsftpd.conf;
sed -i "s|rsa_private_key_file=.*|rsa_private_key_file=/etc/ssl/certificates/vsftpd.pem|gI" /etc/vsftpd.conf;
sed -i  "s/ssl_tlsv2=NO/ssl_sslv2=NO/gI" /etc/vsftpd.conf;
sed -i  "s/ssl_tlsv3=NO/ssl_sslv3=NO/gI" /etc/vsftpd.conf;
sed -i  "s/write_enable=YES/write_enable=NO/gI" /etc/vsftpd.conf;
sed -i  "s/anon_mkdir_write_enable=YES/anon_mkdir_write_enable=NO/gI" /etc/vsftpd.conf;
sed -i  "s/anon_upload_enable=YES/anon_upload_enable=NO/gI" /etc/vsftpd.conf;

echo "force_local_data_ssl=YES
force_local_logins_ssl=YES
ssl_tlsv1=YES
ssl_sslv2=NO
ssl_sslv3=NO" >> /etc/vsftpd.conf;

service vsftpd restart;

iptables -I INPUT -p TCP --dport 21 -m state --state NEW -m recent --set;
iptables -I INPUT -p TCP --dport 21 -m state --state NEW -m recent --update --second 100 --hitcount 3 -j DROP;


# SSH

iptables -I INPUT -p TCP --dport 22 -m state --state NEW -m recent --set;
iptables -I INPUT -p TCP --dport 22 -m state --state NEW -m recent --update --second 100 --hitcount 3 -j DROP;
# basic-config

#!/bin/bash

# Cek distribusi OS
if [ "$(uname -s)" != "Linux" ] || ! grep -qiE 'debian|buntu' /etc/*release; then
    echo "Skrip ini hanya dapat digunakan pada Debian atau Ubuntu."
    exit 1
fi

#!/bin/bash

# update package repository
sudo apt update

# install git
sudo apt install git -y

# install nano
sudo apt install nano -y

# Install OpenSSH-server
sudo apt-get install openssh-server -y

# install x11vnc server
sudo apt-get install -y x11vnc

#input password x11vncserver
echo "resman56adam" | sudo x11vnc -storepasswd /etc/x11vnc.passwd

# clone service x11vnc server
git clone https://github.com/Kaptencepat/X11VNC.git

# move  file service x11vnc
cd X11VNC
mv x11vnc.service /lib/systemd/system/

systemctl enable x11vnc.service
systemctl start x11vnc.sercvice

# Install Google chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

# Menginstal Chrome
sudo dpkg -i google-chrome-stable_current_amd64.deb

# Memperbaiki dependensi yang rusak (jika ada)
sudo apt --fix-broken install -y

# Membersihkan paket yang tidak diperlukan
sudo apt autoremove -y

# Menghapus paket Chrome yang telah diunduh
rm google-chrome-stable_current_amd64.deb


# Masuk ke User adam-user
cd /home/adam-user


# UnInstall docker bila ada
sudo apt-get remove docker docker-engine docker.io containerd runc

# Install paket yang diperlukan untuk menginstal Docker
sudo apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg \
  lsb-release

# Tambahkan Docker GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Tambahkan repository Docker ke sistem
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# Perbarui indeks paket dengan repository Docker baru
sudo apt-get update
#"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
 # "$(. /etc/os-release && echo "stretch")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# Instal Docker

sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Restart servis docker
sudo systemctl restart docker

# Cek versi Docker yang terinstal
if ! command -v docker &> /dev/null
then
    echo "Docker tidak dapat diinstal."
    exit 1
fi
# Install docker compose 

sudo curl -L https://github.com/docker/compose/releases/download/v2.17.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
# Buat direktori untuk Portainer data
docker volume create portainer_data

# Jalankan Portainer sebagai kontainer Docker
docker run -d -p 9000:9000 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

# Periksa apakah Portainer sudah berjalan
if ! sudo docker ps | grep portainer >/dev/null
then
    echo "Portainer tidak dapat dijalankan."
    exit 1
fi

# Install Nginx Proxy Manager
#docker volume create npm_data
#docker run -d -p 8080:8080 -p 8443:8443 --name npm --restart always -v npm_data:/data --network npm_net --env DB_TYPE=mysql --env DB_HOST=npm-db --env DB_PORT=3306 --env DB_USER=npm --env DB_PASSWORD=password jlesage/nginx-proxy-manager

# Install MySQL
#docker network create npm_net
#docker volume create npm_db_data
#docker run -d --name npm-db --restart always --network npm_net --env MYSQL_ROOT_PASSWORD=password --env MYSQL_USER=npm --env MYSQL_PASSWORD=password --env MYSQL_DATABASE=npm -v npm_db_data:/var/lib/mysql mysql:latest

# Cek apakah Nginx Proxy Manager sudah terpasang
#if docker ps | grep -q npm
#then
#    echo "Nginx Proxy Manager berhasil terpasang"
#else
#    echo "Nginx Proxy Manager gagal terpasang"
#    exit 1
#fi
# Instal Nginx
sudo apt-get install -y nginx

# Periksa apakah Nginx sudah terinstal
if ! command -v nginx &> /dev/null
then
    echo "Nginx tidak dapat diinstal."
    exit 1
fi
# clone nginx proxy setting

# Instal PostgreSQL
sudo apt-get install -y postgresql postgresql-contrib

# Periksa apakah PostgreSQL sudah terinstal
if ! command -v psql &> /dev/null
then
    echo "PostgreSQL tidak dapat diinstal."
    exit 1
fi

# Periksa apakah PostgreSQL sudah berjalan
sudo systemctl status postgresql >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "PostgreSQL tidak dapat dijalankan."
    echo "Pastikan untuk memperbarui password untuk pengguna postgres."
    exit 1
fi

# Membuka Google Chrome
google-chrome-stable

# set git credentials
git config --global credential.helper store
git config --global user.name "nisa7"
git config --global user.email "nisa@adamlambs.id"
git config --global user.password "Desti1012"

cd /home/adam-user/

# buat directory adamlis
mkdir adamlis

#masuk directory adamlis
cd /home/adam-user/adamlis

#membuat directory Instalasi
mkdir Instalasi

# Masuk directory Instalasi
cd /home/adam-user/adamlis/Instalasi

# clone repository web-socket 
git clone https://gitlab.com/wahana-meditek-indonesia/lis/web-socket-lis.git 
# clone repository wizzard installer
git clone https://gitlab.com/wahana-meditek-indonesia/lis/adamlabs-installer.git

# masuk directory web-socker-lis
cd /home/adam-user/adamlis/Instalasi/web-socket-lis

# downloads node modules
nmp install

#running container web-socket-lis
#docker-compose up --build -d
sudo pm2 start index.js --log-date-format="YYYY-MM-DD HH:mm:ss Z" --name pemeriksaan -- #--port 7780
# masuk directory adamlabs-installer
cd /home/adam-user/adamlis/Instalasi/adamlabs-installer

# install kebutuhan npm
npm install

# build aplikasi node
npm run build

# start aplikasi
npm run start

echo "Instalasi  selesai."




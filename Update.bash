#!/bin/bash

# Cek distribusi OS
if [ "$(uname -s)" != "Linux" ] || ! grep -qiE 'debian|buntu' /etc/*release; then
    echo "Skrip ini hanya dapat digunakan pada Debian atau Ubuntu."
    exit 1
fi

#!/bin/bash

# update package repository
sudo apt update

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


# Instal Nginx
sudo apt-get install -y nginx

# Periksa apakah Nginx sudah terinstal
if ! command -v nginx &> /dev/null
then
    echo "Nginx tidak dapat diinstal."
    exit 1
fi

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

#running container web-socket-lis
docker-compose up --build -d

# masuk directory adamlabs-installer
cd /home/adam-user/adamlis/Instalasi/adamlabs-installer

# install kebutuhan npm
npm install

# build aplikasi node
npm run build

# start aplikasi
npm run start

echo "Instalasi  selesai."



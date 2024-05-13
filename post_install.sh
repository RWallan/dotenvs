#!/bin/bash

echo "Pacotes básicos"
sudo pacman -S --noconfirm neovim git fastfetch

echo "Melhorando o pacman"
sudo nvim -c '%s/#Color/Color/g' -c '%s/#ParallelDownloads = 5/ParallelDownloads = 10/g' -c 'wq' /etc/pacman.conf

echo "Atualizando sistema"
sudo pacman -Syu --noconfirm

echo "Instalando firmware e firewall"
sudo pacman -S --noconfirm gufw fwupd
sudo ufw enable
fwupdmgr get-updates
fwupdmgr update

echo "Configurando bluetooth"
sudo systemctl start bluetooth.service --now

echo "Instalando codecs"
sudo pacman -S --noconfirm ffmpeg gst-plugin-ugly gst-plugin-good gst-plugin-base gst-plugin-bad gst-libav gstreamer

echo "Instalando compatibilidade com NTFS"
sudo pacman -S --noconfirm ntfs-3g

echo "Instalando yay"
pacman -Sy --needed --noconfirm base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay -Y --gendb

echo "Programming"
yay -S --noconfirm tmux beekeeper-studio-bin docker act github-cli ripgrep
yay -S --noconfirm pyenv tk pipx
yay -S --noconfirm node npm

echo "Python"
yay -S --noconfirm python-pipx
pyenv install 3.10:latest 3.11:latest 3.12:latest
pipx install poetry

echo "Configurando Poetry"
poetry config virtualenvs.prompt "{project_name}"
poetry config virtualenvs.in-project true

echo "Melhorias do terminal"
yay -S eza bat fzf

echo "Outras coisas"
yay -S --noconfirm marktext-bin libreoffice-fresh libreoffice-fresh-pt-br telegram-desktop barrier unzip

echo "Fim"

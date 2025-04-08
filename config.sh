#!/bin/bash
ask_yes_no() {
    while true; do
        read -p "$1 (y/n): " answer
        case $answer in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Пожалуйста, ответьте y (да) или n (нет)";;
        esac
    done
}
echo "Скрипт настройки системы Fedora"
echo "================================="
if ask_yes_no "Хотите обновить систему?"; then
    echo "Обновление системы..."
    sudo dnf update -y
fi
if ask_yes_no "Хотите подключить репозитории RPM Fusion?"; then
    echo "Подключение RPM Fusion..."
    sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1
    sudo dnf update @core
fi
if ask_yes_no "Хотите установить мультимедиа кодеки?"; then
    echo "Установка кодеков..."
    sudo dnf swap ffmpeg-free ffmpeg --allowerasing
    sudo dnf update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
fi
if ask_yes_no "Хотите установить аппаратные кодеки для AMD?"; then
    echo "Установка аппаратных кодеков AMD..."
    sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld
    sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
    sudo dnf swap mesa-va-drivers.i686 mesa-va-drivers-freeworld.i686
    sudo dnf swap mesa-vdpau-drivers.i686 mesa-vdpau-drivers-freeworld.i686
fi
if ask_yes_no "Хотите установить шрифты (Microsoft Core Fonts)?"; then
    echo "Установка шрифтов..."
    sudo dnf install curl cabextract xorg-x11-font-utils fontconfig
    sudo rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
fi
echo "================================="
echo "Настройка завершена!"
# ===================================================
# *      Author : icon97 <p.h.tan97@gmail.com>      *
# *      File Name : install.sh                     *
# *      Version : 1.0                              *
# *      Creation Date : 27/07/2017                 *
# *      Last Modified : 28/07/2017 19:07           *
# *      Description : Install arch on Intel PC     *
# ===================================================

#!/bin/base

# Enable multilib and AUR repositories
sed -i '/\[multilib\]/,+1 s/^#//g' /etc/pacman.conf
echo -e "\n[archlinuxfr]\nSigLevel = Never\nServer = http://repo.archlinux.fr/\$arch" >> /etc/pacman.conf
pacman -Syy

# Install the necessary packages
################################
# Boot
pacumount -R /mnt
rebootman -S grub-efi-x86_64 efibootmgr os-prober --noconfirm --needed

# Network
pacman -S ifplugd --noconfirm --needed
enp=$(ip link | egrep -o 'enp\w*')
systemctl enable netctl-ifplugd@$enp
wlp=$(ip link | egrep -o 'wlp\w*')
if [ -n "$wlp" ]; then
    pacman -S iw dialog wpa_actiond wpa_suppicant --noconfirm --needed
    systemctl enable netctl-auto@$wlp
fi

# System
pacman -S sudo intel-ucode zsh vim git acpi acpid linux-headers --noconfirm --needed
systemctl enable acpid
echo "Do you want install TLP?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) pacman -S tlp --noconfirm --needed;
	    systemctl enable tlp.service;
	    systemctl enable tlp-sleep.service;
	    break;;
        No ) break;;
    esac
done
###################################

# Set locale and time
sed -i '/en_US.UTF-8 UTF-8/s/^#//g' /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
export LANG=en_US.UTF-8

ln -s /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime
hwclock --systohc --utc

# Set hostname
read -p "Set hostname: " hostName
echo $hostName > /etc/hostname

# Set the root password
echo "Set root password:"
passwd

# Create user and set password
read -p "Set user name:" userName
useradd -m -g users -G wheel -s /bin/zsh $userName
echo "Set user password:"
passwd $userName
sed -i '/%wheel ALL=(ALL) ALL/s/^#//g' /etc/sudoers

# Create a new initial RAM disk
mkinitcpio -p linux

# Setup grub
grub-install
grub-mkconfig -o /boot/grub/grub.cfg

# Finish
exit

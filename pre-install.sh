# ===================================================
# *      Author : icon97 <p.h.tan97@gmail.com>      *
# *      File Name : pre-install.sh                 *
# *      Version : 1.0                              *
# *      Creation Date : 28/07/2017                 *
# *      Last Modified : 28/07/2017 19:23           *
# *      Description :                              *
# ===================================================

#!/bin/base

# Select the mirrors
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
grep -E -A 1 ".*Vietnam.*$" /etc/pacman.d/mirrorlist.bak | sed '/--/d' > /etc/pacman.d/mirrorlist

# Install base
pacstrap /mnt base base-devel

# Configure fstab
genfstab -pU /mnt >> /mnt/etc/fstab

# Copy file to new system
cp ~/Arch-master/install.sh /mnt/root
echo -e "\"cd\"\n\"chmod +x install.sh && .install.sh\" to continue install"

# Change root
arch-chroot /mnt /bin/bash

# Finnish and reboot
umount -R /mnt
reboot

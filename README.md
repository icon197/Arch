# Arch Linux
Installations script

## Before installing
    - Make the bootable USB: "dd bs=4M if=/path/to/archlinux.iso of=/dev/sdx status=progress && sync"
    - Configure network: if you're using wifi "wifi-menu"
    - Partition hard drive: with "gdisk /dev/sdx" and "cgdisk /dev/sdx"
    - Format partitions
    - Mount

## How to install
    - wget https://github.com/icon97/Arch/archive/master.tar.gz -O - | tar
    - ./Arch-master/pre-install.sh
    - cd /root
    - chmod +x install.sh && ./install.sh

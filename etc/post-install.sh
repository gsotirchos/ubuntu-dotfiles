#!/bin/bash

# disable user and system zsys snapshots
echo "- Disabling ZFS zsys snapshots"
if modinfo zfs &> /dev/null; then
    systemctl --user stop zsys-user-savestate.timer
    systemctl --user disable zsys-user-savestate.timer
    sudo mv /etc/apt/apt.conf.d/90_zsys_system_autosnapshot \
        /etc/apt/apt.conf.d/90_zsys_system_autosnapshot.disabled
fi

# uninstall default wireless driver, and install working one
echo "- Install working wireless driver and remove default"
sudo apt purge bcmwl-kernel-source
sudo apt-get install broadcom-sta-source
sudo apt-get install broadcom-sta-dkms
sudo apt-get install broadcom-sta-common

# generate nvidia xorg config file (installed driver)
if [[ ! -f /etc/X11/xorg.conf ]]; then
    echo "- Created /etc/X11/xorg.conf"
    sudo nvidia-xconfig
fi

# add brightness adjustment option and hide logo on boot
vendor_name='    VendorName     "NVIDIA Corporation"'
brightness_option=\
'\    Option         "RegistryDwords" "EnableBrightnessControl=1"'
nologo_option='\    Option         "NoLogo"'

xorg_file="/etc/X11/xorg.conf"
if (! grep -q "${brightness_option}" "${xorg_file}"); then
    sed "/${vendor_name}/a\
    ${brightness_option}\n${nologo_option}"\
    "${xorg_file}" > ~/xorg.tmp
fi

sudo mv xorg.tmp /etc/X11/xorg.conf

# disable autostart bluetooth
# TODO comment out line in /etc/bluetooth/main.conf

# install some packages
sudo apt update
sudo apt full-upgrade
sudo apt install tree\
    vim-gtk3 xbacklight\
    exfat-fuse\
    exfat-utils

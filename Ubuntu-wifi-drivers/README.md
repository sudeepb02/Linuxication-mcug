Install the following Wifi drivers for respective manufacturer's hardware<br>
To list hardware
```
    $ lspci -vnn | grep "Network"
```
**Qualcomm Atheros** : *backth10k-dkms_2.0_all.deb*
<br>
```
    $ sudo dpkg -i backth10k-dkms_2.0_all.deb
```
**Broadcomm** : *bcmwl-kernel-source_6.30.223.248+bdcom-0ubuntu0.1_amd64.deb*

```
    $ sudo dpkg -i bcmwl-kernel-source_6.30.223.248+bdcom-0ubuntu0.1_amd64.deb
```

**Realtek** : *dkms_2.2.0.3-1.1ubuntu5.14.04.1_all.deb*

```
    $ sudo dpkg -i dkms_2.2.0.3-1.1ubuntu5.14.04.1_all.deb
```

# Troubleshooting

**Qualcomm Atheros**
<br>
Ubuntu 16.04 users should just need to update and upgrade
sudo apt-get update && sudo apt-get upgrade

Reboot

For other flavours, or if the above steps don't work, just follow the below steps :
<br>

    sudo apt-get install build-essential linux-headers-$(uname -r) git
    echo "options ath10k_core skip_otp="y" | sudo tee /etc/modprobe.d/ath10k_core.conf
    wget https://www.kernel.org/pub/linux/kernel/projects/backports/stable/v4.4.2/backports-4.4.2-1.tar.gz
    tar -zxvf backports-4.4.2-1.tar.gz
    cd backport-4.4.2-1
    make defconfig-wifi
    make 
    sudo make install
    git clone https://github.com/sudeepb02/ath10k-firmware.git
    sudo cp -r ath10k-firmware/QCA9377 /lib/firmware/ath10k/
    sudo cp /lib/firmware/ath10k/QCA9377/hw1.0/firmware-5.bin_WLAN.TF.1.0-00267-1 /lib/firmware/ath10k/QCA9377/hw1.0/firmware-5.bin
    sudo reboot



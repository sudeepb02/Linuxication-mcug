Install the following Wifi drivers for respective manufacturer's hardware
To list hardware
	$ lspci -vnn | grep "Network"

**Qualcomm Atheros** : *backth10k-dkms_2.0_all.deb*
	$ sudo dpkg -i backth10k-dkms_2.0_all.deb

**Broadcomm** : *bcmwl-kernel-source_6.30.223.248+bdcom-0ubuntu0.1_amd64.deb*
	$ sudo dpkg -i bcmwl-kernel-source_6.30.223.248+bdcom-0ubuntu0.1_amd64.deb

**Realtek** : *dkms_2.2.0.3-1.1ubuntu5.14.04.1_all.deb*
	$ sudo dpkg -i dkms_2.2.0.3-1.1ubuntu5.14.04.1_all.deb



#!/bin/bash
cp -a "/root/exported_debs/." /var/cache/apt/
dpkg -i /var/cache/apt/archives/*.deb
cp -a /usr/bin/python3.9 /usr/bin/python3

pip3 install /root/exported_pip3_packages/*.whl
# The following works around a hard coded HTTPS request requiring an internet connection.
# https://github.com/WoeUSB/WoeUSB-ng/blob/18e8918f75af26c0258a5b5f7bdb13acb76611eb/WoeUSB/core.py#L375C10-L375C10
sed -i 's#urllib\.request\.urlretrieve.*#"uefi-ntfs.img"#' /usr/local/lib/python3.9/dist-packages/WoeUSB/core.py
#sed -i 's#shutil\.move.*#download_directory="/root/slax"#' /usr/local/lib/python3.9/dist-packages/WoeUSB/core.py
sed -i 's#shutil\.move(fileName#shutil.move("/root/slax/uefi-ntfs.img"#' /usr/local/lib/python3.9/dist-packages/WoeUSB/core.py

#!/bin/bash
exported_debs_full_path=/root/exported_debs/
cd $exported_debs_full_path
cp -a ./. /var/cache/apt/
cd /var/cache/apt/archives
dpkg -i *.deb
cp -a /usr/bin/python3.9 /usr/bin/python3

exported_pip3_packages=/root/exported_pip3_packages/
cd $exported_pip3_packages
pip3 install ./numpy-1.25.0-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
pip3 install ./termcolor-2.3.0-py3-none-any.whl
pip3 install ./WoeUSB-ng-0.2.12.tar.gz
# The following works around a hard coded HTTPS request requiring an internet connection.
# https://github.com/WoeUSB/WoeUSB-ng/blob/18e8918f75af26c0258a5b5f7bdb13acb76611eb/WoeUSB/core.py#L375C10-L375C10
sed -i 's#urllib\.request\.urlretrieve.*#"uefi-ntfs.img"#' /usr/local/lib/python3.9/dist-packages/WoeUSB/core.py
#sed -i 's#shutil\.move.*#download_directory="/root/slax"#' /usr/local/lib/python3.9/dist-packages/WoeUSB/core.py
sed -i 's#shutil\.move(fileName#shutil.move("/root/slax/uefi-ntfs.img"#' /usr/local/lib/python3.9/dist-packages/WoeUSB/core.py

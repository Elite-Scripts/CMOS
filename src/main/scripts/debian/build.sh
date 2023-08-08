# https://wiki.debian.org/RepackBootableISO#What_to_do_if_no_file_.2F.disk.2Fmkisofs_exists
cd /root/mkiso/
xorriso -as mkisofs \
    -r -J --joliet-long \
    -V 'slax' \
    -boot-load-size 4 -boot-info-table -no-emul-boot \
    --modification-date='2023012111474800' \
    -eltorito-alt-boot -e 'slax/boot/EFI/Boot/bootx64.efi'  \
    -c 'slax/boot/isolinux.boot' \
    -b 'slax/boot/isolinux.bin' \
    -o ./build/CMOS.iso \
    deb
cd /root/mkiso/deb/
zip -r ../build/CMOS_ISO_Contents.zip ./*
chmod a+rwx ../build
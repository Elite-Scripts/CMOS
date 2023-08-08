FROM debian:bullseye-20230612-slim

WORKDIR /root/mkiso/
RUN apt-get update && apt-get -y install xorriso squashfs-tools wget && \
    wget -O slax-64bit.iso "https://ftp.linux.cz/pub/linux/slax/Slax-11.x/slax-64bit-11.6.0.iso" && \
    wget -O sb2dir https://sourceforge.net/projects/linux-live-slack-debian/files/Scripts/sb2dir/download && \
    wget -O dir2sb https://sourceforge.net/projects/linux-live-slack-debian/files/Scripts/dir2sb/download && \
    chmod +x ./sb2dir ./dir2sb && \
    xorriso -osirrox on -indev ./slax-64bit.iso -extract / ./deb && \
    # The warfront1.txt test file will be available at the following full path upon successful boot to Slax.
    # /media/sr0/slax/warfront1.txt
    touch /root/mkiso/deb/slax/warfront1.txt && \
    sed -i 's/slax.flags=perch,automount/slax.flags=toram/' /root/mkiso/deb/slax/boot/EFI/Boot/syslinux.cfg && \
    # https://liveng.readthedocs.io/en/latest/secure-boot.html
    mv /root/mkiso/deb/slax/boot/EFI/Boot/bootx64.efi /root/mkiso/deb/slax/boot/EFI/Boot/loader.efi && \
    wget -O /root/mkiso/deb/slax/boot/EFI/Boot/bootx64.efi https://blog.hansenpartnership.com/wp-uploads/2013/PreLoader.efi && \
    wget -O /root/mkiso/deb/slax/boot/EFI/Boot/HashTool.efi https://blog.hansenpartnership.com/wp-uploads/2013/HashTool.efi && \
    cp -a /root/mkiso/deb/slax/boot/EFI/. /root/mkiso/deb/EFI/



# The apt install was generated via the following command executed on Slax
# PACKAGES="p7zip-full python3-pip python3-wxgtk4.0" && apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances --no-pre-depends ${PACKAGES} | grep "^\w" >> test.txt
RUN apt install -y --download-only p7zip-full python3-pip python3-wxgtk4.0 p7zip libc6 libgcc-s1 libstdc++6 ca-certificates python3-distutils python3-setuptools python3-wheel python-pip-whl python3 python3-pil python3-six libwxbase3.0-0v5 libwxgtk3.0-gtk3-0v5 libcrypt1 gcc-10-base openssl debconf cdebconf python3-lib2to3 python3-pkg-resources python3.9 libpython3-stdlib mime-support python3-pil.imagetk libfreetype6 libimagequant0 libjpeg62-turbo liblcms2-2 libtiff5 libwebp6 libwebpdemux2 libwebpmux3 libxcb1 zlib1g libexpat1 libcairo2 libgdk-pixbuf2.0-0 libgl1 libglib2.0-0 libgtk-3-0 libnotify4 libpango-1.0-0 libpangocairo-1.0-0 libpng16-16 libsm6 libx11-6 libssl1.1 libdebian-installer4 libnewt0.52 libselinux1 libslang2 libtextwrap1 dpkg python3.9-minimal libpython3.9-stdlib media-types mailcap python3-tk libbrotli1 libdeflate0 libjbig0 liblzma5 libzstd1 libxau6 libxdmcp6 libfontconfig1 libpixman-1-0 libxcb-render0 libxcb-shm0 libxext6 libxrender1 libgdk-pixbuf-2.0-0 libgdk-pixbuf-xlib-2.0-0 libglvnd0 libglx0 libffi7 libmount1 libpcre3 adwaita-icon-theme hicolor-icon-theme shared-mime-info libatk-bridge2.0-0 libatk1.0-0 libcairo-gobject2 libcolord2 libcups2 libepoxy0 libfribidi0 libharfbuzz0b libjson-glib-1.0-0 libpangoft2-1.0-0 librest-0.7-0 libwayland-client0 libwayland-cursor0 libwayland-egl1 libxcomposite1 libxcursor1 libxdamage1 libxfixes3 libxi6 libxinerama1 libxkbcommon0 libxrandr2 libgtk-3-common fontconfig libthai0 libice6 libuuid1 libx11-data libpcre2-8-0 tar libpython3.9-minimal tzdata libbz2-1.0 libdb5.3 libmpdec3 libncursesw6 libnsl2 libreadline8 libsqlite3-0 libtinfo6 libtirpc3 perl blt libtcl8.6 libtk8.6 tk8.6-blt2.5 libbsd0 fontconfig-config libgdk-pixbuf2.0-common libglx-mesa0 libblkid1 gtk-update-icon-cache libxml2 libatspi2.0-0 libdbus-1-3 libatk1.0-data libudev1 libavahi-client3 libavahi-common3 libgnutls30 libgssapi-krb5-2 libgraphite2-3 libjson-glib-1.0-common libsoup-gnome2.4-1 libsoup2.4-1 xkb-data dconf-gsettings-backend gconf-gsettings-backend libthai-data libdatrie1 x11-common readline-common libtirpc-common perl-base perl-modules-5.32 libperl5.32 libxft2 libxss1 libmd0 ucf fonts-dejavu-core ttf-bitstream-vera fonts-liberation fonts-liberation2 fonts-croscore fonts-freefont-otf fonts-freefont-ttf fonts-urw-base35 fonts-texgyre libdrm2 libglapi-mesa libx11-xcb1 libxcb-dri2-0 libxcb-dri3-0 libxcb-glx0 libxcb-present0 libxcb-sync1 libxcb-xfixes0 libxshmfence1 libxxf86vm1 libgl1-mesa-dri libicu67 libavahi-common-data libgmp10 libhogweed6 libidn2-0 libnettle8 libp11-kit0 libtasn1-6 libunistring2 libcom-err2 libk5crypto3 libkrb5-3 libkrb5support0 glib-networking libpsl5 dconf-service libdconf1 gconf-service libgconf-2-4 lsb-base install-info libgdbm-compat4 libgdbm6 coreutils sensible-utils libdrm-common libdrm-amdgpu1 libdrm-intel1 libdrm-nouveau2 libdrm-radeon1 libelf1 libllvm11 libsensors5 libvulkan1 libcap2 libkeyutils1 libproxy1v5 glib-networking-services glib-networking-common gsettings-desktop-schemas dbus-user-session dbus-x11 libdbus-glib-1-2 libldap-2.4-2 gconf2-common libpciaccess0 libedit2 libz3-4 libsensors-config dbus libpam-systemd systemd libsasl2-2 adduser libapparmor1 libaudit1 libcap-ng0 libpam0g libpam-runtime systemd-sysv libacl1 libcryptsetup12 libgpg-error0 libip4tc2 libkmod2 liblz4-1 libseccomp2 util-linux mount libsasl2-modules-db passwd libaudit-common libpam-modules libargon2-1 libdevmapper1.02.1 libjson-c5 login libsemanage1 dmsetup libsemanage-common libsepol1 && \
    # The following apt downloads are extras required to get WoeUSB to run properly.
    # The apt install was generated via the following command executed on Slax
    # PACKAGES="parted grub2" && apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances --no-pre-depends ${PACKAGES} | grep "^\w" >> test.txt
    apt install -y --download-only parted grub2 libc6 libparted2 libreadline8 libtinfo6 grub-pc grub-common libgcc-s1 libcrypt1 libblkid1 libdevmapper1.02.1 libuuid1 dmidecode readline-common debconf cdebconf grub2-common grub-pc-bin ucf libefiboot1 libefivar1 libfreetype6 libfuse2 liblzma5 gettext-base gcc-10-base libselinux1 libudev1 dmsetup dpkg install-info libdebian-installer4 libnewt0.52 libslang2 libtextwrap1 coreutils sensible-utils libbrotli1 libpng16-16 zlib1g libpcre2-8-0 tar parted grub2 libc6 libparted2 libreadline8 libtinfo6 grub-pc grub-common libgcc-s1 libcrypt1 libblkid1 libdevmapper1.02.1 libuuid1 dmidecode readline-common debconf cdebconf grub2-common grub-pc-bin ucf libefiboot1 libefivar1 libfreetype6 libfuse2 liblzma5 gettext-base gcc-10-base libselinux1 libudev1 dmsetup dpkg install-info libdebian-installer4 libnewt0.52 libslang2 libtextwrap1 coreutils sensible-utils libbrotli1 libpng16-16 zlib1g libpcre2-8-0 tar && \
    cp -a /var/cache/apt/ /root/mkiso/exported_debs

COPY ./src/main/scripts/slax/ /root/slax/
COPY ./src/main/scripts/debian/ /root/debian/
COPY ./src/main/resources/bootlogo.png /root/mkiso/deb/slax/boot/bootlogo.png

RUN chmod -R a+rwx /root/slax && \
    apt install -y python3-pip && \
    mkdir -p /root/mkiso/exported_pip3_packages && \
    pip3 download -d /root/mkiso/exported_pip3_packages -r /root/debian/requirements.txt && \
    chmod +r ./deb/slax/03-desktop.sb && \
    mkdir -p ./03-desktop.sb && ./sb2dir ./deb/slax/03-desktop.sb ./03-desktop.sb/ && \
    echo '[startup] {xterm -hold -maximized -e "/root/slax/create_boot_media.sh"}'  >> ./03-desktop.sb/root/.fluxbox/apps && \
    cp -a /root/mkiso/exported_debs/ ./03-desktop.sb/root/exported_debs/ && \
    cp -a /root/mkiso/exported_pip3_packages ./03-desktop.sb/root/exported_pip3_packages/ && \
    cp -a /root/slax/ ./03-desktop.sb/root/slax/ && \
    wget -O ./03-desktop.sb/root/slax/uefi-ntfs.img https://github.com/pbatard/rufus/raw/v4.1/res/uefi/uefi-ntfs.img && \
    chmod a+rwx ./03-desktop.sb/root/slax/uefi-ntfs.img && \
    rm ./deb/slax/03-desktop.sb && ./dir2sb ./03-desktop.sb ./deb/slax/03-desktop.sb && \
    apt install -y zip

#CMD sleep 10000
CMD /bin/bash /root/debian/build.sh
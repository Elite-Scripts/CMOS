#!/bin/bash
target_device_root_file_list="autorun.ico autorun.inf EFI readme.txt slax syslinux.cfg System Volume Information"
target_device_root_file_list_alternative="EFI readme.txt slax System Volume Information"
target_device_root_file_list_alternative_2="EFI readme.txt slax"
target_device_root_file_list=$(echo $target_device_root_file_list | tr -d '[:space:]')
target_device_root_file_list_alternative=$(echo $target_device_root_file_list_alternative | tr -d '[:space:]')
target_device_root_file_list_alternative_2=$(echo $target_device_root_file_list_alternative_2 | tr -d '[:space:]')
red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)

possible_mounts=$(lsblk -nlo NAME,RM,MOUNTPOINT --ascii | grep -v MOUNTPOINT | awk '$2 == "1" && $3 == "" {print $1}' | grep -E "1|2")
counter=1

generic_error_handling() {
  echo "${red}Stopping this script in 1 minute${reset}"
  sleep 1m
  exit
}

get_iso_files() {
  IFS=$'\n'
  for possible_mount in $possible_mounts; do
    echo $counter $possible_mount
    device_to_mount=/dev/$possible_mount
    path_to_mount="/mount_$counter_$possible_mount"
    echo "${green}Creating the following directory and attempting to mount to it.${reset}"
    echo $path_to_mount
    mkdir -p $path_to_mount
    mount $device_to_mount $path_to_mount
    if [ $? -ne 0 ]; then
      echo "We were unable to mount $device_to_mount"
    else
      echo "${green}We were able to mount $device_to_mount."
      echo "Listing out the root directory of $device_to_mount.${reset}"
      mount_file_list=$(ls $path_to_mount | grep -vE '\.(iso|zip\.00[1-9]|part[12])$' | sort | tr '\n' ' ' | tr -d '[:space:]')
      echo $mount_file_list

      if [[ "$mount_file_list" == "$target_device_root_file_list" ]] || \
         [[ "$mount_file_list" == "$target_device_root_file_list_alternative" ]] || \
         [[ "$mount_file_list" == "$target_device_root_file_list_alternative_2" ]]; then
        echo "${green}We found the correct USB.${reset}"
        mkdir -p /iso
        find / -name "*.iso" -exec cp {} /iso \;
        find / -name "*.001" -exec 7z x {} -o"/iso" \;
        part1_file=$(find / -path /proc -prune -o -type f -not -name "._*" -name "*.part1" -print)
        part2_file=$(find / -path /proc -prune -o -type f -not -name "._*" -name "*.part2" -print)
        if [ -z "$part1_file" ]; then
            echo "No matching part files found, skipping part file concatenation."
        else
            echo "${green}concatenating the following two files: $part1_file $part2_file${reset}"
            cat $part1_file $part2_file > /iso/concatenated_iso.iso
        fi
        export target_device=$device_to_mount
        export target_device_parent_device="/dev/$(lsblk -no pkname $target_device)"
        return
      else
        echo "${red}By comparing the file directory listing, we have determined that this isn't the correct USB.${reset}"
      fi

      echo "${green}We are now unmounting $device_to_mount, as we no longer need data off of it.${reset}"
      umount $path_to_mount
    fi
    let "counter++"
  done
  echo "${red}Error: We were not able to find the USB to write the ISO to. Please report this issue.${reset}"
  generic_error_handling
}

verify_iso_file() {
  iso_files=$(find /iso -maxdepth 1 -type f -name "*.iso")

  if [[ -z $iso_files ]]; then
    echo "${red}Error: We expected at least one ISO file. Make sure to copy an ISO file onto your USB.${reset}"
    generic_error_handling
  else
    file_count=$(echo "$iso_files" | wc -l)
    if [[ $file_count -gt 1 ]]; then
      echo "${red}Error: Too many ISO files given.${reset}"
      echo "Files in /iso directory:"
      echo "$iso_files"
      generic_error_handling
    else
      echo "${green}ISO file in /iso directory: $iso_files${reset}"
      export target_iso=$iso_files
      return
    fi
  fi
}

/bin/bash /root/slax/install_woeusb.sh
get_iso_files
verify_iso_file
echo $target_device
echo $target_device_parent_device
echo $target_iso
woeusb --target-filesystem NTFS --device $target_iso $target_device_parent_device
if [ $? -ne 0 ]; then
  echo "${red}Error: We were not able to create the bootable USB. Please report this issue.${reset}"
else
  echo "${green}We successfully created the bootable USB!${reset}"
  echo "${green}It is safe to power off your PC now.${reset}"
  echo "${green}We will automatically restart your PC in 30 seconds.${reset}"
  sleep 30
  reboot --force
fi



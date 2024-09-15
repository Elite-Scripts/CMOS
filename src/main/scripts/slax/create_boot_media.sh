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

generic_error_handling() {
  echo "${red}Stopping this script in 1 minute${reset}"
  sleep 1m
  exit
}

get_top_level_device() {
  DEVICE="$1"
  TOP_DEVICE=$(lsblk -no pkname $DEVICE)
  if [ -z "$TOP_DEVICE" ]; then
    echo "The top-level device for $DEVICE is: $DEVICE"
  else
    echo "The top-level device for $DEVICE is: /dev/$TOP_DEVICE"
  fi
}

get_iso_files() {
  # Fetch all unmounted blockdevices, sort them by whether they're removable or not
  possible_mounts=$(lsblk -lpJ -o NAME,RM,MOUNTPOINT | jq -r '.[] | map(select(.mountpoint == null)) | sort_by(.rm | not) | map(.name) | join("\n")')
  counter=1
  IFS=$'\n'
  echo "Possible mounts: $possible_mounts"
  echo "Starting to iterate over the possible mounts..."
  for possible_mount in $possible_mounts; do
    echo $counter $possible_mount
    device_to_mount=$possible_mount
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
      mount_file_list=$(ls $path_to_mount | grep -vE '\.(iso|zip\.00[1-9]|part[1-9]|part[1-9][0-9])$' | sort | tr '\n' ' ' | tr -d '[:space:]')
      echo $mount_file_list

      if [[ "$mount_file_list" == "$target_device_root_file_list" ]] || \
         [[ "$mount_file_list" == "$target_device_root_file_list_alternative" ]] || \
         [[ "$mount_file_list" == "$target_device_root_file_list_alternative_2" ]]; then
        echo "${green}We found the correct USB.${reset}"
        mkdir -p /iso
        find / -name "*.iso" -exec cp {} /iso \;
        find / -name "*.001" -exec 7z x {} -o"/iso" \;
        for fileNum in {1..20}
        do
          part_file=$(find / -path /proc -prune -o -type f -not -name "._*" -name "*.part${fileNum}" -print)
          if [ -z "$part_file" ]; then
            echo "No more part files found, finished concatenation."
            break
          else
            echo "${green}Adding the following file to the ISO: $part_file${reset}"
            cat $part_file >> /iso/concatenated_iso.iso
          fi
        done
        export target_device=$device_to_mount
        export target_device_parent_device=$(get_top_level_device "$target_device")
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



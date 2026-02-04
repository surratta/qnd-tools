#!/bin/bash


# stuff that's supposed to be mounted
fstab_mounts=$(egrep -v "^#|^$| swap | proc " /etc/fstab | awk '{print $2}' | egrep -v "^/media/(floppy|cdrom)|^none")

# stuff that actually is mounted
mtab_mounts=$(egrep "^/" /etc/mtab | awk '{print $2}' | sort)

set -e

# format nice output
max_mount_point_length=0
for fstab_mount_point in $fstab_mounts; do
    if [ ${#fstab_mount_point} -gt $max_mount_point_length ]; then
        max_mount_point_length=${#fstab_mount_point}
    fi
done
((max_mount_point_length += 5))

# this does the checking
for fstab_mount_point in $fstab_mounts; do
    match=0
    for mtab_mount_point in $mtab_mounts; do
        if [ "$fstab_mount_point" == "$mtab_mount_point" ]; then
            match=1
            continue;
        fi
    done
    
    echo -n "$fstab_mount_point"
    for ((i=1; i -le $(($COLUMNS - (($max_mount_point_length - ${#fstab_mount_point})))); i++)); do
        echo -n " "
    done
    if [ $match -eq 1 ]; then
        echo "OK"
    else
        echo "MISSING"
    fi
done

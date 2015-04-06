#!/bin/sh
#
# Raspberry Pi Setup System - Expand FileSystem Code
# This code was borrowed from the raspi-config tool published under the MIT license
# Big thanks to the team. It was modified to remove whiptail which I am not using.
#

if ! [ -h /dev/root ]; then
	echo "/dev/root does not exist or is not a symlink. Don't know how to expand"
	return 0
fi

ROOT_PART=$(sudo readlink /dev/root)
PART_NUM=${ROOT_PART#mmcblk0p}

if [ "$PART_NUM" = "$ROOT_PART" ]; then
	echo "/dev/root is not an SD card. Don't know how to expand"
	echo "PART NUM = $PART_NUM"
	echo "ROOT PART = $ROOT_PART"
	return 0
fi

# NOTE: the NOOBS partition layout confuses parted. For now, let's only
# agree to work with a sufficiently simple partition layout
if [ "$PART_NUM" -ne 2 ]; then
	echo "Your partition layout is not currently supported by this tool. You are probably using NOOBS, in which case your root filesystem is already expanded anyway."
	return 0
fi

LAST_PART_NUM=$(sudo parted /dev/mmcblk0 -ms unit s p | tail -n 1 | cut -f 1 -d:)

if [ "$LAST_PART_NUM" != "$PART_NUM" ]; then
	echo "/dev/root is not the last partition. Don't know how to expand"
	echo "Last Part Num = $LAST_PART_NUM"
	echo "Part Num = $PART_NUM"
	return 0
fi

# Get the starting offset of the root partition
PART_START=$(sudo parted /dev/mmcblk0 -ms unit s p | grep "^${PART_NUM}" | cut -f 2 -d:)
[ "$PART_START" ] || return 1

# Return value will likely be error for fdisk as it fails to reload the
# partition table because the root fs is mounted

sudo fdisk /dev/mmcblk0 <<EOF
p
d
$PART_NUM
n
p
$PART_NUM
$PART_START

p
w
EOF
# ASK_TO_REBOOT=1		# Removing this line because the parent script will reboot anyway

# now set up an init.d script
sudo cat <<\EOF > ./resize2fs_once &&
#!/bin/sh
### BEGIN INIT INFO
# Provides:          resize2fs_once
# Required-Start:
# Required-Stop:
# Default-Start: 2 3 4 5 S
# Default-Stop:
# Short-Description: Resize the root filesystem to fill partition
# Description:
### END INIT INFO

. /lib/lsb/init-functions

case "$1" in
	start)
		log_daemon_msg "Starting resize2fs_once" &&
		resize2fs /dev/root &&
		rm /etc/init.d/resize2fs_once &&
		update-rc.d resize2fs_once remove &&
		log_end_msg $?
		;;
	*)
		echo "Usage: $0 start" >&2
		exit 3
		;;
esac
EOF
	sudo mv ./resize2fs_once /etc/init.d
	sudo chmod +x /etc/init.d/resize2fs_once &&
	sudo update-rc.d resize2fs_once defaults &&
	if [ "$INTERACTIVE" = True ]; then
		echo "Root partition has been resized.\nThe filesystem will be enlarged upon the next reboot"
	fi

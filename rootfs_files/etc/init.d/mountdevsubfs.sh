#! /bin/sh
### BEGIN INIT INFO
# Provides:          mountdevsubfs
# Required-Start:    mountkernfs
# Required-Stop:
# Should-Start:      udev
# X-Start-Before:    keyboard-setup.sh
# Default-Start:     S
# Default-Stop:
# Short-Description: Mount special file systems under /dev.
# Description:       Mount the virtual filesystems the kernel provides
#                    that ordinarily live under the /dev filesystem.
### END INIT INFO
#
# This script gets called multiple times during boot
#

PATH=/sbin:/bin
TTYGRP=5
TTYMODE=620
[ -f /etc/default/devpts ] && . /etc/default/devpts

KERNEL="$(uname -s)"

. /lib/init/vars.sh
. /lib/init/tmpfs.sh

. /lib/lsb/init-functions
. /lib/init/mount-functions.sh

# idempotent, but does not change extant symlinks (or directories, for /dev/fd)
trylink() {
	test -h "/dev/$1" || test -d "/dev/$1" || ln -s -- "$2" "/dev/$1" || {
		echo "W: unable to ensure link /dev/$1 -> $2"
		ls -lad "/dev/$1"
	} >&2
}

# May be run several times, so must be idempotent.
# $1: Mount mode, to allow for remounting
mount_filesystems() {
	MNTMODE="$1"

	# Ensure standard I/O nodes are present
	trylink fd /proc/self/fd
	trylink stdin fd/0
	trylink stdout fd/1
	trylink stderr fd/2

	# Mount a tmpfs on /run/shm
	mount_shm "$MNTMODE"

	# Mount /dev/pts
	if [ "$KERNEL" = Linux ]
	then
		if [ ! -d /dev/pts ]
		then
			mkdir --mode=755 /dev/pts
			[ -x /sbin/restorecon ] && /sbin/restorecon /dev/pts
		fi
		domount "$MNTMODE" devpts "" /dev/pts devpts "-onoexec,nosuid,gid=$TTYGRP,mode=$TTYMODE"
	fi
}

case "$1" in
  "")
	echo "Warning: mountdevsubfs should be called with the 'start' argument." >&2
	mount_filesystems mount_noupdate
	;;
  start)
  # MOS Custom - add proper messages
  log_action_begin_msg "Mounting device and subsystem filesystems"
	mount_filesystems mount_noupdate
	log_action_end_msg "$?"
	;;
  restart|reload|force-reload)
	mount_filesystems remount
	;;
  stop|status)
	# No-op
	;;
  *)
	echo "Usage: mountdevsubfs [start|stop]" >&2
	exit 3
	;;
esac

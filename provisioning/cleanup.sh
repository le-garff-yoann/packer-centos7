#!/bin/bash -eux

rm -f /etc/machine-id
touch /etc/machine-id

# Make sure udev doesn't block our network: http://6.ptmc.org/?p=1649
if grep -q -i 'release 6' /etc/redhat-release
then
    rm -f /etc/udev/rules.d/70-persistent-net.rules
    mkdir /etc/udev/rules.d/70-persistent-net.rules

    ls -1 /etc/sysconfig/network-scripts/ifcfg-* | while read ndev
    do
        if [[ "$(basename $ndev)" != 'ifcfg-lo' ]]
        then
            sed -i '/^HWADDR/d' "$ndev";
            sed -i '/^UUID/d' "$ndev";
        fi
    done
fi
# Better fix that persists package updates: http://serverfault.com/a/485689
touch /etc/udev/rules.d/75-persistent-net-generator.rules
ls -1 /etc/sysconfig/network-scripts/ifcfg-* | while read ndev
do
    if [[ "$(basename $ndev)" != 'ifcfg-lo' ]]
    then
        sed -i '/^HWADDR/d' "$ndev";
        sed -i '/^UUID/d' "$ndev";
    fi
done
rm -rf /dev/.udev/

DISK_USAGE_BEFORE_CLEANUP=$(df -h)

[[ $CLEANUP_BUILD_TOOLS  =~ true || $CLEANUP_BUILD_TOOLS =~ 1 || $CLEANUP_BUILD_TOOLS =~ yes ]] && \
    yum -y remove gcc libmpc mpfr cpp kernel-devel kernel-headers

yum -y --enablerepo='*' clean all

rm -rf /tmp/*

rpmdb --rebuilddb
rm -f /var/lib/rpm/__db*

# Delete any logs that have built up during the install
find /var/log/ -name *.log -exec rm -f {} \;

set +e
swapuuid=$(/sbin/blkid -o value -l -s UUID -t TYPE=swap)
case "$?" in
	2|0) ;;
	*) exit 1 ;;
esac
set -e
if [[ -n $swapuuid ]]
then
    # Whiteout the swap partition to reduce box size swap is disabled till reboot
    swappart=$(readlink -f "/dev/disk/by-uuid/${swapuuid}")
    /sbin/swapoff "${swappart}"
    dd if=/dev/zero of="${swappart}" bs=1M || echo "dd exit code $? is suppressed"
    /sbin/mkswap -U "${swapuuid}" "${swappart}"
fi

# Zero out the free space to save space in the final image. Contiguous zeroed space compresses down to nothing.
dd if=/dev/zero of=/EMPTY bs=1M || echo "dd exit code $? is suppressed"
rm -f /EMPTY

# Block until the empty file has been removed, otherwise, Packer will try to kill the box while the disk is still full and that's bad
sync

echo $DISK_USAGE_BEFORE_CLEANUP

df -h

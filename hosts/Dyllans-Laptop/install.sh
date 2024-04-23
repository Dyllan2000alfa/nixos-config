DISK='/dev/disk/by-id/nvme-Sabrent_7FBC071408D900106738'
MNT=$(mktemp -d)

nvme format $DISK 1 --force

sgdisk -n1:0:+4096M -t1:EF00 -I $DISK
sgdisk -n2:0:-38GB -t2:BF01 -I $DISK
sgdisk -n3:0:+0 -t3:8200 -I $DISK

for i in ${DISK}; do
   cryptsetup open --type plain --key-file /dev/random "${i}"-part3 "${i##*/}"-part3
   mkswap /dev/mapper/"${i##*/}"-part3
   swapon /dev/mapper/"${i##*/}"-part3
done

for i in ${DISK}; do
   # see PASSPHRASE PROCESSING section in cryptsetup(8)
   printf "Dman2003()$" | cryptsetup luksFormat --type luks2 "${i}"-part2 -
   printf "Dman2003()$" | cryptsetup luksOpen "${i}"-part2 luks-laptop-rpool-"${i##*/}"-part2 -
done

# shellcheck disable=SC2046
zpool create \
    -o ashift=12 \
    -o autotrim=on \
    -R "${MNT}" \
    -O acltype=posixacl \
    -O canmount=off \
    -O dnodesize=auto \
    -O normalization=formD \
    -O relatime=on \
    -O xattr=sa \
    -O mountpoint=none \
    laptop-rpool \
   $(for i in ${DISK}; do
      printf '/dev/mapper/luks-laptop-rpool-%s ' "${i##*/}-part2";
     done)

zfs create -o mountpoint=none laptop-rpool/ROOT
zfs create -o mountpoint=none laptop-rpool/Data
zfs create -o canmount=noauto -o mountpoint=legacy laptop-rpool/ROOT/nixos
zfs create -o mountpoint=legacy laptop-rpool/Data/home

mount -o X-mount.mkdir -t zfs laptop-rpool/ROOT/nixos "${MNT}"
mount -o X-mount.mkdir -t zfs laptop-rpool/Data/home "${MNT}"/home

for i in ${DISK}; do
 mkfs.vfat -n EFI "${i}"-part1
done

for i in ${DISK}; do
 mount -t vfat -o fmask=0077,dmask=0077,iocharset=iso8859-1,X-mount.mkdir "${i}"-part1 "${MNT}"/boot
 break
done

nixos-generate-config --root "${MNT}"

nano "${MNT}"/etc/nixos/hardware-configuration.nix

networking.hostId = "c4odf3on";

   boot.initrd.luks.devices = {
"luks-rpool-nvme-Sabrent_7FBC071408D900106738-part2".device = "/dev/disk/by-id/nvme-Sabrent_7FBC071408D900106738-part2";
};



nixos-install  --root "${MNT}"

cd /
umount -Rl "${MNT}"
zpool export -a

reboot
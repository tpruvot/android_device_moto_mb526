# This script is included in squisher
# It is the final build step (after OTA package)

# set in squisher
# DEVICE_OUT=$ANDROID_BUILD_TOP/out/target/product/mb526
# DEVICE_TOP=$ANDROID_BUILD_TOP/device/moto/mb526
# VENDOR_TOP=$ANDROID_BUILD_TOP/vendor/motorola/jordan_plus
# DEVICE_COMMON=$ANDROID_BUILD_TOP/device/moto/jordan-common

# Delete unwanted apps
rm -f $REPACK/ota/system/app/RomManager.apk
rm -f $REPACK/ota/system/app/VideoEditor.apk
rm -f $REPACK/ota/system/lib/libvideoeditor*

# Remove big videos
rm -f $REPACK/ota/system/media/video/*.480p.mp4

# these scripts are not required or bad
rm -f $REPACK/ota/system/etc/init.d/04modules

# device specific kernel modules
cp $DEVICE_TOP/modules/* $REPACK/ota/system/lib/modules/

# add an empty script to prevent logcat errors (moto init.rc)
touch $REPACK/ota/system/bin/mount_ext3.sh
chmod +x $REPACK/ota/system/bin/mount_ext3.sh

mkdir -p $REPACK/ota/system/etc/terminfo/x
cp $REPACK/ota/system/etc/terminfo/l/linux $REPACK/ota/system/etc/terminfo/x/xterm

# prebuilt boot, devtree, logo & updater-script

rm -f $REPACK/ota/boot.img

cp -f $DEVICE_COMMON/updater-script $REPACK/ota/META-INF/com/google/android/updater-script

# Opensource init binary
cp -f $DEVICE_OUT/root/init $REPACK/ota/system/bootmenu/2nd-init/init

# Use a prebuilt adbd configured for root access instead of normal one, for dev purpose
cp -f $REPACK/ota/system/bootmenu/binary/adbd $REPACK/ota/system/bin/adbd

cp -f $DEVICE_COMMON/bootmenu/binary/2nd-init $REPACK/ota/system/bootmenu/binary/2nd-init

# use the static busybox as bootmenu shell, and some static utilities
cp -f $DEVICE_OUT/utilities/busybox $REPACK/ota/system/bootmenu/binary/busybox
cp -f $DEVICE_OUT/utilities/lsof $REPACK/ota/system/bootmenu/binary/lsof

# ril fix
cp -f $REPACK/ota/system/lib/hw/audio.a2dp.default.so $REPACK/ota/system/lib/liba2dp.so

# battd
cp -f $VENDOR_TOP/bin/battd_plus $REPACK/ota/system/bin/battd

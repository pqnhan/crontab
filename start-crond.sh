#!/system/bin/sh
# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODDIR=${0%/*}
DIR1="/data/adb/modules/crontab/cronjobs"
DIR2="/data/media/0/cronjobs"

# This script will be executed in late_start service mode
# More info in the main Magisk thread
# TimeZoon 8,China. I do not known how to use tzselect
export TZ=Asia/Ho_Chi_Minh

# Check if both directories exist
if [ ! -d "$DIR1" ] || [ ! -d "$DIR2" ]; then
  # If not, create both directories with -p option
  mkdir -p "$DIR1" "$DIR2"
  # Create the file called root inside the directory
  touch "$DIR2/root"
  # Copy cronjob files and set executable mode for it.
  cp -u $DIR2/* "$DIR1/"
  chmod 744 "$DIR1/"*
else
  # If yes, copy files from /data/media/0/cronjobs/ to that directory
  cp $DIR2/* "$DIR1/"
  # Grant 'chmod 744' execution rights to all files in that directory
  chmod 744 "$DIR1/"*
fi

# executable
echo 'root:x:0:0:root:/data:/system/bin/sh' > /system/etc/passwd  
/data/adb/magisk/busybox crond -c $DIR1 

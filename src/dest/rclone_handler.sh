#!/usr/bin/env sh

# Source: location on Drobo
source="$HOME/test_rclone_data"

# Dest: pre-configured remote location
dest="$usb/test_rclone_backup"


prog_dir="$(dirname "$(realpath "${0}")")"
rclone_bin="${prog_dir}/bin/rclone"
rclone_jobber="${prog_dir}/lib/rclone_jobber.sh"
conffile="${prog_dir}/etc/rclone.conf"

name="rclone"
tmp_dir="/tmp/DroboApps/${name}"
logfile="${tmp_dir}/log.txt"


move_old_files_to="dated_files"

options="--config="$conffile" --log-file="$logfile" --dry-run"

$rclone_jobber "$source" "$dest" "$move_old_files_to" "$options" "$(basename $0)" "$monitoring_URL" "$rclone_bin" "$logfile"

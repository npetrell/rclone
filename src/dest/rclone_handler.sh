#!/bin/sh

# Note that the shebang must be /bin/sh else the pidof command in the
# rclone_jobber won't function correctly

# Source: location on Drobo
source="$HOME/fake_dir"

# Dest: pre-configured remote location
dest="b2-test:smiv-test/bang"


prog_dir="$(dirname "$(realpath "${0}")")"
rclone_bin="${prog_dir}/bin/rclone"
rclone_jobber="${prog_dir}/lib/rclone_jobber.sh"
conffile="${prog_dir}/etc/rclone.conf"

name="rclone"
tmp_dir="/tmp/DroboApps/${name}"
logfile="${tmp_dir}/log.txt"


move_old_files_to="dated_files"

options="-vvv --config="$conffile""

$rclone_jobber "$source" "$dest" "$move_old_files_to" "$options" "$(basename $0)" "" "$rclone_bin" "$logfile"

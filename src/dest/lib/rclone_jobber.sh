#!/usr/bin/env sh
# rclone_jobber.sh version 1.5
# Tutorial, backup-job examples, and source code at https://github.com/wolfv6/rclone_jobber
# Logging options are headed by "# set log".  Details are in the tutorial's "Logging options" section.

################################### license ##################################
# rclone_jobber.sh is a script that calls rclone sync to perform a backup.
# Written in 2018 by Wolfram Volpi, contact at https://github.com/wolfv6/rclone_jobber/issues
# To the extent possible under law, the author(s) have dedicated all copyright and related and
# neighboring rights to this software to the public domain worldwide.
# This software is distributed without any warranty.
# You should have received a copy of the CC0 Public Domain Dedication along with this software.
# If not, see http://creativecommons.org/publicdomain/zero/1.0/.
# rclone_jobber is not affiliated with rclone.

################################# parameters #################################
source="$1"            #the directory to back up (without a trailing slash)
dest="$2"              #destination=$dest/last_snapshot
move_old_files_to="$3" #move_old_files_to is one of:
                       # "dated_directory" - move old files to a dated directory (an incremental backup)
                       # "dated_files"     - move old files to old_files directory, and append move date to file names (an incremental backup)
                       # ""                - old files are overwritten or deleted (a plain one-way sync backup)
options="$4"           #rclone options like "--filter-from=filter_patterns --checksum --log-level="INFO" --dry-run"
                       #do not put these in options: --backup-dir, --suffix, --log-file
job_name="$5"          #job_name="$(basename $0)"
monitoring_URL="$6"    #cron monitoring service URL to send email if cron failure or other error prevented back up
rclone_bin="$7"
logfile="$8"

################################ set variables ###############################
# $new is the directory name of the current snapshot
# $timestamp is time that old file was moved out of new (not time file was copied from source)
new="last_snapshot"
timestamp="$(date +%F_%T)"
#timestamp="$(date +%F_%H%M%S)"  #time w/o colons if thumb drive is FAT format, which does not allow colons in file name

# set log_file path
path="$(realpath "$0")"                 #path of this script
log_file="$logfile"                     #replace path extension with "log"
#log_file="/var/log/rclone_jobber.log"  #for Logrotate

# set log_option for rclone
log_option="--log-file=$log_file"       #log to log_file
#log_option="--syslog"                  #log to systemd journal

################################## functions #################################
send_to_log()
{
    msg="$1"

    # set log - send msg to log
    echo "$msg" >> "$log_file"                             #log msg to log_file
    #printf "$msg" | systemd-cat -t RCLONE_JOBBER -p info   #log msg to systemd journal
}

# print message to echo, log, and popup
print_message()
{
    urgency="$1"
    msg="$2"
    message="${urgency}: $job_name $msg"

    echo "$message"
    send_to_log "$(date +%F_%T) $message"
    # warning_icon="/usr/share/icons/Adwaita/32x32/emblems/emblem-synchronizing.png"   #path in Fedora 28
    # # notify-send is a popup notification on most Linux desktops, install libnotify-bin
    # command -v notify-send && notify-send --urgency critical --icon "$warning_icon" "$message"
}

################################# range checks ################################
if [ -z "$source" ]; then
    print_message "ERROR" "aborted because source is empty string."
    exit 1
fi

if [ -z "$dest" ]; then
    print_message "ERROR" "aborted because dest is empty string."
    exit 1
fi

# if source is empty
if ! ( ls -1A $source | grep -q . ); then
    print_message "ERROR" "aborted because source is empty."
    exit 1
fi

# if job is already running (maybe previous run didn't finish)

# JC: -x option (return process ids of shells running the named scripts)
# is not supported in the BusyBox version of pidof. However, this behaviour seems to be default so
# I've removed the flag.

#if pidof -o $PPID -x "$job_name"; then
if pidof -o $PPID "$job_name"; then
    print_message "WARNING" "aborted because it is already running."
    exit 1
fi

############################### move_old_files_to #############################
# deleted or changed files are removed or moved, depending on value of move_old_files_to variable
# default move_old_files_to="" will remove deleted or changed files from backup
if [ "$move_old_files_to" = "dated_directory" ]; then
    # move deleted or changed files to archive/$(date +%Y)/$timestamp directory
    backup_dir="--backup-dir=$dest/archive/$(date +%Y)/$timestamp"
elif [ "$move_old_files_to" = "dated_files" ]; then
    # move deleted or changed files to old directory, and append _$timestamp to file name
    backup_dir="--backup-dir=$dest/old_files --suffix=_$timestamp"
elif [ "$move_old_files_to" != "" ]; then
    print_message "WARNING" "Parameter move_old_files_to=$move_old_files_to, but should be dated_directory or dated_files.\
  Moving old data to dated_directory."
    backup_dir="--backup-dir=$dest/$timestamp"
fi

################################### back up ##################################

# B2 doesn't support server side move or copy so "$backup_dir" must be omitted
cmd="$rclone_bin sync $source $dest/$new $log_option $options"
# cmd="$rclone_bin sync $source $dest/$new $backup_dir $log_option $options"

# progress message
echo "Back up in progress $timestamp $job_name"
echo "$cmd"

# set logging to verbose
#send_to_log "$timestamp $job_name"
#send_to_log "$cmd"

$cmd
exit_code=$?

############################ confirmation and logging ########################
if [ "$exit_code" -eq 0 ]; then            #if no errors
    confirmation="$(date +%F_%T) completed $job_name"
    echo "$confirmation"
    send_to_log "$confirmation"
    send_to_log ""
    wget $monitoring_URL -O /dev/null
    exit 0
else
    print_message "ERROR" "failed.  rclone exit_code=$exit_code"
    send_to_log ""
    exit 1
fi

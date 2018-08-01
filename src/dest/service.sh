#!/usr/bin/env sh
#
# Rclone service

# import DroboApps framework functions
. /etc/service.subr

framework_version="2.1"
name="Rclone"
version="1.42"
description="Rclone is a command line program to sync files and directories to and from various cloud storage services"
depends=""
webui="WebUI"

prog_dir="$(dirname "$(realpath "${0}")")"
daemon="${prog_dir}/bin/rclone"
conffile="${prog_dir}/etc/rclone.conf"
tmp_dir="/tmp/DroboApps/${name}"
pidfile="${tmp_dir}/pid.txt"
logfile="${tmp_dir}/log.txt"

start() {
  # Start ${daemon}, ensure ${pidfile is created}, detach from parent
  process
  ${daemon} --config ${conffile}
}

main "$@"

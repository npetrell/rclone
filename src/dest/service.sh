#!/bin/sh

. /etc/service.subr

framework_version="2.1"

name="Rclone"
version="1.42"
description="Rclone is a command line program to sync files and directories to and from various cloud storage services"
depends=""
webui="WebUI"

prog_dir="$(dirname "$(realpath "${0}")")"
daemon="${prog_dir}/bin/simple-app-daemon"
pidfile="/tmp/DroboApps/${name}/pid.txt"

start() {
  # Start ${daemon}, ensure ${pidfile is created}, detach from parent
  process
  ${daemon} --pidfile="${pidfile}" --daemon
}

main "$@"

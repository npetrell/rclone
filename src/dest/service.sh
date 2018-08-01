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

certfile="${prog_dir}/etc/ssl/certs/ca-certificates.crt"

start() {
  # Start ${daemon}, ensure ${pidfile is created}, detach from parent
  process
  env SSL_CERT_FILE=${certfile} ${daemon} --config ${conffile}
}


# boilerplate
if [ ! -d "${tmp_dir}" ]; then mkdir -p "${tmp_dir}"; fi
exec 3>&1 4>&2 1>> "${logfile}" 2>&1
STDOUT=">&3"
STDERR=">&4"
echo "$(date +"%Y-%m-%d %H-%M-%S"):" "${0}" "${@}"
set -o errexit  # exit on uncaught error code
set -o nounset  # exit on unset variable
set -o xtrace   # enable script tracing

main "${@}"

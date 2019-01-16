### RCLONE ###
_get_rclone() {
  local VERSION="1.45"
  local FOLDER="rclone-v${VERSION}"
  local FILE="rclone-v${VERSION}-linux-arm.zip"
  local URL="https://github.com/ncw/rclone/releases/download/v${VERSION}/${FILE}"

  _download_zip "${FILE}" "${URL}" "${FOLDER}"
  f=(target/*) && mv target/*/* target/ && rmdir "${f[@]}"
  mkdir -p "${DEST}/bin"
  mv target/rclone "${DEST}/bin/"
}


### CERTIFICATES ###
_build_certificates() {
  # update CA certificates on a Debian/Ubuntu machine:
  #sudo update-ca-certificates
  mkdir -p "${DEST}/etc/ssl/certs/"
  cp -vf /etc/ssl/certs/ca-certificates.crt "${DEST}/etc/ssl/certs/"
  ln -vfs certs/ca-certificates.crt "${DEST}/etc/ssl/cert.pem"
}


_build() {
  _get_rclone
  _build_certificates
  _package
}

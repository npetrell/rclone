### RCLONE ###
_build_rclone() {
  local VERSION="1.42"
  local FOLDER="src/github.com/ncw/rclone"
  local BRANCH="v${VERSION}.tar.gz"
  local URL="https://github.com/ncw/rclone/archive/${FILE}"

  _download_tgz "${FILE}" "${URL}" "${FOLDER}"
  pushd "target"
  local GOPATH="$(pwd)"
  go build -i -v
  popd
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
  _build_rclone
  _build_certificates
  _package
}

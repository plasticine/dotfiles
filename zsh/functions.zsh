# Create a new directory and enter it
mkd() {
  mkdir -p "$@"
  cd "$@" || exit
}

# Make a temporary directory and enter it
tmpd() {
  local dir
  if [ $# -eq 0 ]; then
    dir=$(mktemp -d)
  else
    dir=$(mktemp -d -t "${1}.XXXXXXXXXX")
  fi
  cd "$dir" || exit
}

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
targz() {
  local tmpFile="${1%/}.tar"
  tar -cvf "${tmpFile}" --exclude=".DS_Store" "${1}" || return 1

  size=$(
  stat -f"%z" "${tmpFile}" 2> /dev/null; # OS X `stat`
  stat -c"%s" "${tmpFile}" 2> /dev/null # GNU `stat`
  )

  local cmd=""
  if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
    # the .tar file is smaller than 50 MB and Zopfli is available; use it
    cmd="zopfli"
  else
    if hash pigz 2> /dev/null; then
      cmd="pigz"
    else
      cmd="gzip"
    fi
  fi

  echo "Compressing .tar using \`${cmd}\`…"
  "${cmd}" -v "${tmpFile}" || return 1
  [ -f "${tmpFile}" ] && rm "${tmpFile}"
  echo "${tmpFile}.gz created successfully."
}

# Determine size of a file or total size of a directory
fs() {
  if du -b /dev/null > /dev/null 2>&1; then
    local arg=-sbh
  else
    local arg=-sh
  fi
  # shellcheck disable=SC2199
  if [[ -n "$@" ]]; then
    du $arg -- "$@"
  else
    du $arg -- .[^.]* *
  fi
}

# Start an HTTP server from a directory, optionally specifying the port
server() {
  local port="${1:-8000}"
  sleep 1 && open "http://localhost:${port}/" &
  # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
  # And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
  python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
}

# Change into a directory and list it
cd() {
  builtin cd "$@" && ll
}

# Run `dig` and display the most useful info
digga() {
  dig +nocmd "$1" any +multiline +noall +answer
}

# Show all the names (CNs and SANs) listed in the SSL certificate
# for a given domain
getcertnames() {
  if [ -z "${1}" ]; then
    echo "ERROR: No domain specified."
    return 1
  fi

  local domain="${1}"
  echo "Testing ${domain}..."
  echo ""; # newline

  local tmp
  tmp=$(echo -e "GET / HTTP/1.0\\nEOT" \
    | openssl s_client -connect "${domain}:443" 2>&1)

  if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
    local certText
    certText=$(echo "${tmp}" \
      | openssl x509 -text -certopt "no_header, no_serial, no_version, \
      no_signame, no_validity, no_issuer, no_pubkey, no_sigdump, no_aux")
    echo "Common Name:"
    echo ""; # newline
    echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//"
    echo ""; # newline
    echo "Subject Alternative Name(s):"
    echo ""; # newline
    echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
      | sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\\n" | tail -n +2
    return 0
  else
    echo "ERROR: Certificate not found."
    return 1
  fi
}

# Copy
setup_ssh_key() {
  SSH_PUB_FILE="~/.ssh/id_rsa.pub"
  scp $SSH_PUB_FILE $1:.ssh/authorized_keys 'chown -R `whoami`:`whoami` ~/.ssh; chmod 700 ~/.ssh; chmod 600 ~/.ssh/authorized_keys;'
}

git_stats() {
  git log --shortstat --author "Justin Morris" --since "52 weeks ago" | \
    grep "files changed" | \
    awk '{files+=$1; inserted+=$4; deleted+=$6} END {print "files changed", files, "lines inserted:", inserted, "lines deleted:", deleted}'
}

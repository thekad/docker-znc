#!/bin/sh -x
# adjusted from https://github.com/jimeh/docker-znc/blob/master/docker-entrypoint.sh

# Options.
DATADIR="/data"

# Build modules from source.
if [ -d "${DATADIR}/modules" ]; then
  # Find module sources.
  modules=$(find "${DATADIR}/modules" -name "*.cpp")

  # Build modules.
  for module in $modules; do
    if [ -d "$module" ]; then
      echo "Building module $module..."
      cd "$(dirname "$module")"
      znc-buildmod "$module"
      cd -
    fi
  done
fi

SSL="false"
if [ -f "${DATADIR}/ssl/znc.pem" ]; then
  SSL="true"
  SSL_CERT_FILE="SSLCertFile = ${DATADIR}/ssl/znc.pem"
fi

# Create default config if it doesn't exist
if [ ! -f "${DATADIR}/configs/znc.conf" ]; then
  echo "Creating a default configuration..."
  mkdir -vp "${DATADIR}/configs"
  cat /znc.conf.default | \
    sed -e "s%##SSL##%${SSL}%" | \
    sed -e "s%##SSL_CERT_FILE##%${SSL_CERT_FILE}%" > "${DATADIR}/configs/znc.conf"
fi

# Start ZNC.
echo "Starting ZNC..."
exec znc --no-color --foreground --datadir="$DATADIR" $@

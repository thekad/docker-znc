#!/bin/sh -xe
# adjusted from https://github.com/jimeh/docker-znc/blob/master/docker-entrypoint.sh

# Options.
DATADIR="/data"
CRT_FILE="${SSL_CRT:-/ssl/fullchain.pem}"
KEY_FILE="${SSL_KEY:-/ssl/privkey.pem}"
DHP_FILE="${SSL_DHP:-/ssl/dhparam.pem}"
DEPS="${DEPENDENCIES}"

if [ -n "$DEPS" ]; then
  echo "Installing specified dependencies..."
  apk update
  apk add $DEPS
fi

# Build modules from source.
if [ -d "${DATADIR}/modules" ]; then
  # Find module sources.
  modules=$(find "${DATADIR}/modules" -name "*.cpp")

  # Build modules.
  for module in $modules; do
    echo "Building module $module..."
    moddir="$(dirname "$module")"
    modfile="$(basename "$module" .cpp)"
    cd $moddir
    CXXFLAGS="$CXXFLAGS" LIBS="$CXXFLAGS" znc-buildmod "${modfile}.cpp"
    mv -f "${modfile}.so" "${DATADIR}/modules/${modfile}.so"
    cd -
  done
fi

SSL="false"
if [ -e "${CRT_FILE}" ] && [ -e "${KEY_FILE}" ]; then
  SSL="true"
  SSL_CERT_FILE="SSLCertFile = ${CRT_FILE}\nSSLKeyFile = ${KEY_FILE}"
  if [ -e "${DHP_FILE}" ]; then
    echo "Diffie-Hellman params file found, enabling"
    SSL_CERT_FILE="${SSL_CERT_FILE}\nSSLDHParamFile = ${DHP_FILE}"
  fi
else
  echo "Need both cert ${CRT_FILE} and key ${KEY_FILE} to exist"
fi

# Create default config if it doesn't exist
if [ ! -e "${DATADIR}/configs/znc.conf" ]; then
  echo "Creating a default configuration..."
  mkdir -vp "${DATADIR}/configs"
  cat /znc.conf.default | \
    sed -e "s%##SSL##%${SSL}%" | \
    sed -e "s%##SSL_CERT_FILE##%${SSL_CERT_FILE}%" > "${DATADIR}/configs/znc.conf"
fi

# Start ZNC.
echo "Starting ZNC..."
exec znc --no-color --foreground --datadir="$DATADIR" $@

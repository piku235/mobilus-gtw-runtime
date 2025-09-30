#!/bin/sh

REPO=piku235/mobilus-gtw-runtime
PACKAGE_NAME="runtime.tar.gz"
PACKAGE_URL="https://github.com/$REPO/releases/latest/download/$PACKAGE_NAME"
RUNTIME_DIR=/opt/jungi

if [ -d $RUNTIME_DIR ]; then
  echo "runtime is already installed"
  exit 1
fi

cd /tmp

echo "Downloading the runtime"
wget -qO "$PACKAGE_NAME" --no-check-certificate "$PACKAGE_URL"

if [ $? -ne 0 ]; then
    echo "Failed to download the runtime"
    exit 1
fi

tempdir=$(mktemp -d)

cleanup() {
    [ -n "$tempdir" ] && rm -rf "$tempdir" || true
}

trap cleanup EXIT

echo "Extracting the runtime"
gzip -dc "$PACKAGE_NAME" | tar -xf - -C $tempdir .

if [ $? -ne 0 ]; then
    echo "Failed to extract the runtime"
    exit 1
fi

mkdir -p "$tempdir/files/$RUNTIME_DIR/.runtime"
cp "$tempdir/version" "$tempdir/files/$RUNTIME_DIR/.runtime"
(cd "$tempdir/files" && find . \( -type f -o -type l \)) | sed 's|^\./||' > "$tempdir/files/$RUNTIME_DIR/.runtime/files"

echo "Done!"
echo "Now you can type: $RUNTIME_DIR/scripts/pkg to install a desired package on Cosmo GTW"

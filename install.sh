#!/bin/sh
set -e

REPO=piku235/mobilus-gtw-runtime
PACKAGE_NAME="runtime.tar.gz"
PACKAGE_URL="https://github.com/$REPO/releases/latest/download/$PACKAGE_NAME"
RUNTIME_DIR=/opt/jungi

if [ -d $RUNTIME_DIR ]; then
  echo "runtime is already installed"
  exit 1
fi

cd /tmp
wget -qO "$PACKAGE_NAME" --no-check-certificate "$PACKAGE_URL"

if [ $? -eq 0 ]; then
    echo "Downloading the runtime"
else
    echo "Failed to download the runtime"
    exit 1
fi

echo "Extracting the runtime"
gzip -dc "$package_file" | tar -xf - -C / .

if [ $? -ne 0 ]; then
    echo "Failed to extract the runtime"
    exit 1
fi

echo "Done!"
echo "Now you can type: $RUNTIME_DIR/scripts/pkg to install a desired package on Cosmo GTW"

#!/bin/sh

REPO=piku235/mobilus-gtw-runtime
PACKAGE_URL="https://github.com/$REPO/releases/latest/download/runtime.tar.gz"
RUNTIME_DIR=/opt/jungi

run_script() {
    script=$1

    if [ -x "$script" ]; then
        "$script"
        rc=$?

        if [ $rc -ne 0 ]; then
            exit $rc
        fi
    fi
}

install_mobilus_initd() {
    cat <<'EOF' > /etc/init.d/mobilus
#!/bin/sh /etc/rc.common

START=98

USE_PROCD=1
PROG=/mobilus/mobilus

start_service() {
    procd_open_instance
    procd_set_param command $PROG
    procd_set_param stdout 1
    procd_set_param stderr 1
    procd_close_instance
}

EOF
    chmod +x /etc/init.d/mobilus

    echo "Deactivating old mobilus autostart"
    mv /etc/rc.local /etc/rc.local.old # backup
    echo "exit 0" > /etc/rc.local

    echo "Killing mobilus"
    pkill mobilus

    echo "Enabling and starting new mobilus service"
    /etc/init.d/mobilus enable
    /etc/init.d/mobilus start
}

if [ -d $RUNTIME_DIR ]; then
  echo "runtime is already installed"
  exit 1
fi

tempdir=$(mktemp -d)

cleanup() {
    [ -n "$tempdir" ] && rm -rf "$tempdir" || true
}

trap cleanup EXIT

echo "Downloading the runtime"
wget -qO "$tempdir/.pkg" --no-check-certificate "$PACKAGE_URL"

if [ $? -ne 0 ]; then
    echo "Failed to download the runtime"
    exit 1
fi

echo "Extracting the runtime"
gzip -dc "$tempdir/.pkg" | tar -xf - -C $tempdir .

if [ $? -ne 0 ]; then
    echo "Failed to extract the runtime"
    exit 1
fi

run_script "$tempdir/.runtime/preinst"

echo "Copying files ..."
mkdir -p "$RUNTIME_DIR/.runtime"
cp "$tempdir/.runtime/version" "$RUNTIME_DIR/.runtime"

cp -ar "$tempdir/"* "$RUNTIME_DIR"
(cd "$tempdir" && find . \( -type f -o -type l \) ! -path '*/.*') | sed 's|^\./||' > "$RUNTIME_DIR/.runtime/files"

[ -x "$tempdir/.runtime/prerm" ] && cp "$tempdir/.runtime/prerm" "$RUNTIME_DIR/.runtime"
[ -x "$tempdir/.runtime/postrm" ] && cp "$tempdir/.runtime/postrm" "$RUNTIME_DIR/.runtime"

install_mobilus_initd
run_script "$tempdir/.runtime/postinst"

echo "Done!"
echo "Now use: $RUNTIME_DIR/scripts/pkg to install any package you want on Cosmo GTW"

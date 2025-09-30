# ⚡ Runtime for Mobilus Cosmo GTW

A modern OpenWRT runtime for **Mobilus Cosmo GTW** that runs on the legacy **OpenWRT 15.05.1**. This runtime leverages the dynamic linker and libraries from **OpenWRT 24**, enabling modern applications to run without upgrading the system. With it, you can run apps like [**mobmatter**](https://github.com/piku235/mobmatter) and [**moblink**](https://github.com/piku235/moblink) directly on **Cosmo GTW**.

## Overview

The runtime comes together with a lightweight package manager replica that is entirely written in bash for simplicity.

Currently, the package manager supports two packages: `mobmatter` and `moblink`.

To install a package:

```bash
/opt/jungi/scripts/pkg install <package_name>
```

To update the package:

```bash
/opt/jungi/scripts/pkg update <package_name>
```

And to remove the package

```bash
/opt/jungi/scripts/pkg remove <package_name>
```

## Installation

Log in to **Cosmo GTW** via SSH and run:

```bash
cd /tmp && wget --no-check-certificate https://raw.githubusercontent.com/piku235/mobilus-gtw-runtime/main/install.sh
chmod a+x install.sh
./install.sh
```

The runtime will be installed at `/opt/jungi`.

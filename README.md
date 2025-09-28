# Runtime for Mobilus Cosmo GTW

A newer runtime target for **Mobilus Cosmo GTW** that runs on the old **OpenWRT 15.05.1**. This runtime uses dynamic linker and libraries from **OpenWRT 23.05.5**. It enables to run modern apps compiled against GCC 12+. Thanks to it you can run on **Cosmo GTW** such apps like **mobmatter** and **moblink**.

## Overview

The runtime comes together with a lightweight package manager replica that is entirely written in bash for simplicity.

Currently, the package manager supports two packages: `mobmatter` and `moblink`.

To install a package:

```bash
scripts/pkg install mobmatter
```

To update the package:

```bash
scripts/pkg update mobmatter
```

And to remove the package

```bash
scripts/pkg remove mobmatter
```

## Installation

Log in to **Cosmo GTW** via SSH and run:

```bash
cd /tmp && wget --no-check-certificate https://raw.githubusercontent.com/piku235/mobilus-gtw-runtime/main/install.sh
chmod a+x install.sh
./install.sh
```

The runtime will be installed at `/opt/jungi`.

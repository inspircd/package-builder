## InspIRCd Packages

### About

This repository contains scripts for building InspIRCd packages. Currently, it has support for:

* RPM on CentOS 7

Support for packaging systems and platformed is planned. See the [open issues](https://github.com/inspircd/inspircd-packages/issues/3) for details.

### Requirements

To build the packages you will need the following software:

* Bash 4 or newer
* Docker

### Usage

To build packages:

1. Set the `INSPIRCD_VERSION` environment variable to an InspIRCd tag.
2. Run the `./build.sh` script in your shell.
3. Get a cup of tea whilst packages are built.

The packages will be built into the `./build` directory.

### License

These scripts are licensed under the same license as InspIRCd (GPLv2).

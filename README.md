## InspIRCd Packages

### About

This repository contains scripts for building InspIRCd packages. Currently, it has support for:

* deb on Debian 11 and 12
* deb on Ubuntu 20.04 and 22.04
* RPM on CentOS 7
* RPM on Rocky Linux 8 and 9

Support for packaging systems and platforms is planned. See the [open issues](https://github.com/inspircd/inspircd-packages/issues/3) for details.

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

### Advanced Usage

The following environment variables can be set to change the behaviour of the build scripts:

#### INSPIRCD_REPOSITORY (default: `inspircd/inspircd`)

The GitHub repository to build the specified version from. This is useful if you have a custom fork you want to test changes in.

#### INSPIRCD_MODULES (default: *varies*)

A space-delimited list of the [extra modules](https://docs.inspircd.org/3/modules/#extra-modules) to build. If not set it defaults to all of the modules which have dependencies available and can legally be shipped in binary form.

#### INSPIRCD_PACKAGES (default: `deb rpm html`)

A space-delimited list of the package types to build. The current supported options are:

Name | Description
---- | -----------
deb  | Build the deb packages for Debian-based distributions.
rpm  | Build the RPM packages for RHEL-based distributions.
html | Build the web index for the packages. Should always be listed last.

#### INSPIRCD_REVISION (default: `1`)

Sets the revision of the package. This is useful if you are rebuilding the package and want it to take preference over a previously built version.

### License

These scripts are licensed under the same license as InspIRCd (GPLv2).

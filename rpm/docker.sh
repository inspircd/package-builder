#!/bin/bash
set -e

# The location of the RPM spec file.
SPEC='/root/sources/inspircd.spec'

# The directory that the RPM packages are built in.
RPMBUILD='/root/rpmbuild'

# Install the required tools and development packages.
yum install --assumeyes \
	gcc-c++ \
	gnutls-devel \
	make \
	rpmdevtools

# Set up the development environment.
rpmdev-setuptree
chown 'root:root' ${SPEC}

# Build the package.
spectool --get-files --sourcedir ${SPEC}
rpmbuild -ba ${SPEC}

# Copy the packages to the output directory.
mv "${RPMBUILD}/RPMS/$(uname -p)/"*.rpm "/root/packages"
mv "${RPMBUILD}/SRPMS/"*.rpm "/root/packages"

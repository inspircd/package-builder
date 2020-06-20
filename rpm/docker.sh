#!/bin/bash
set -e

# The location of the RPM spec file.
SPEC='/root/sources/inspircd.spec'

# The directory which packages are copied to.
PACKAGES='/root/packages'

# The file which package details are written to.
PACKAGEDB="${PACKAGES}/packages.yml"

# The directory that the RPM packages are built in.
RPMBUILD='/root/rpmbuild'

# Install the required tools and development packages.
yum install --assumeyes \
	gcc-c++ \
	make \
	rpmdevtools \
	${DISTRO_PACKAGES}

# Set up and build the package.
rpmdev-setuptree
spectool --get-files --sourcedir ${SPEC}
rpmbuild -ba ${SPEC}

# Copy the packages to the output directory.
echo "${DISTRO_NAME}:" >> ${PACKAGEDB}
for PACKAGE in "${RPMBUILD}/RPMS/$(uname -p)/"*.rpm "${RPMBUILD}/SRPMS/"*.rpm
do
	mv ${PACKAGE} ${PACKAGES}
	echo "  - $(basename ${PACKAGE})" >> ${PACKAGEDB}
done

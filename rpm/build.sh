#!/bin/bash
set -e

if [ -z "${INSPIRCD_ROOT_DIR}" ]
then
	>&2 echo 'This script should not be used directly!'
	exit 1
fi

if [ -n "${RPM_DISABLED}" ]
then
	echo 'Skipping RPM packages because RPM_DISABLED is set.'
	return
fi

# The RPM platforms that we build on.
declare -A RPM_PLATFORMS=(
	["CentOS 7"]="centos:7"
	["CentOS 8"]="centos:8"
)

# The path to the the RPM .spec file.
SPECFILE="${INSPIRCD_ROOT_DIR}/rpm/inspircd.spec"

# Perform the setup for RPM packages.
cp "${SPECFILE}.in" ${SPECFILE}
sed -i "s/@@INSPIRCD_VERSION@@/${INSPIRCD_VERSION}/g" ${SPECFILE}
sed -i "s/@@INSPIRCD_REVISION@@/${INSPIRCD_REVISION}/g" ${SPECFILE}

# Build the RPM packages.
for RPM_PLATFORM in "${!RPM_PLATFORMS[@]}"
do
	docker pull ${RPM_PLATFORMS[${RPM_PLATFORM}]}
	docker run --rm \
		-e "DISTRO_NAME=${RPM_PLATFORM}" \
		-v "${INSPIRCD_ROOT_DIR}/rpm:/root/sources" \
		-v "${INSPIRCD_BUILD_DIR}:/root/packages" \
		-w '/root' \
		${RPM_PLATFORMS[${RPM_PLATFORM}]} \
		'/root/sources/docker.sh'
done

# Clean out the garbage.
rm -f ${SPECFILE}

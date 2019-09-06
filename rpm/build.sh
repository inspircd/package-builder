#!/bin/bash
set -e

if [ -z "${INSPIRCD_ROOT_DIR}" ]
then
	>&2 echo 'This script should not be used directly!'
	exit 1
fi

# The RPM platforms that we build on.
declare -A RPM_PLATFORMS=(
	["CentOS 7"]="centos:7"
)

# Perform the setup for RPM packages.
cp "${INSPIRCD_ROOT_DIR}/rpm/inspircd.spec.in" "${INSPIRCD_ROOT_DIR}/rpm/inspircd.spec"
sed -i "s/@@INSPIRCD_VERSION@@/${INSPIRCD_VERSION}/g" "${INSPIRCD_ROOT_DIR}/rpm/inspircd.spec"
sed -i "s/@@INSPIRCD_REVISION@@/${INSPIRCD_REVISION}/g" "${INSPIRCD_ROOT_DIR}/rpm/inspircd.spec"

# Build the RPM packages.
for RPM_PLATFORM in "${!RPM_PLATFORMS[@]}"
do
	docker pull ${RPM_PLATFORMS[${RPM_PLATFORM}]}
	docker run --rm \
		-v "${INSPIRCD_ROOT_DIR}/rpm:/root/sources" \
		-v "${INSPIRCD_BUILD_DIR}:/root/packages" \
		-w '/root' \
		${RPM_PLATFORMS[${RPM_PLATFORM}]} \
		'/root/sources/docker.sh'
done

# Clean out the garbage.
rm -f "${INSPIRCD_ROOT_DIR}/rpm/inspircd.spec"

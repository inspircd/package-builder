#!/bin/bash
set -e

if [ -z "${INSPIRCD_ROOT_DIR}" ]
then
	>&2 echo 'This script should not be used directly!'
	exit 1
fi

if [ -n "${WWW_DISABLED}" ]
then
	echo 'Skipping the web interface because WWW_DISABLED is set.'
	return
fi

echo 'Building the web interface ...'

# Build the web interface.
docker pull ruby:slim
docker run --rm \
	-v "${INSPIRCD_ROOT_DIR}/www:/root/sources" \
	-v "${INSPIRCD_BUILD_DIR}:/root/packages" \
	-w '/root' \
	ruby:slim \
	'/root/sources/docker.rb'

#!/bin/bash
set -e

# Bash 4 is required for associative arrays.
if [ "${BASH_VERSINFO[0]}" -lt 4 ]
then
	>&2 echo 'Bash 4+ is required by this script!'
	exit 1
fi

# The INSPIRCD_VERSION variable must be set.
if [ -z "${INSPIRCD_VERSION}" ]
then
	>&2 echo 'You must set the INSPIRCD_VERSION environment variable!'
	exit 1
fi

# The INSPIRCD_REVISION variable may be set.
if [ -z "${INSPIRCD_REVISION}" ]
then
	echo 'INSPIRCD_REVISION is not set; defaulting to 1.'
	INSPIRCD_REVISION='1'
fi

# The INSPIRCD_PACKAGES variable may be set.
if [ -z "${INSPIRCD_PACKAGES}" ]
then
	echo "INSPIRCD_PACKAGES is not set; enabling all packages."
	INSPIRCD_PACKAGES_DEFAULT='1'
	INSPIRCD_PACKAGES='rpm html'
fi

# The INSPIRCD_MODULES variable may be set.
INSPIRCD_MODULES_DEFAULT=''
if [ -z "${INSPIRCD_MODULES}" ]
then
	echo "INSPIRCD_MODULES is not set; enabling all modules."
	INSPIRCD_MODULES_DEFAULT='1'
	INSPIRCD_MODULES='argon2 geo_maxmind ldap mysql pgsql regex_pcre regex_posix regex_re2 regex_stdlib regex_tre sqlite3 ssl_gnutls ssl_mbedtls ssl_openssl sslrehashsignal'
fi

# Modules which should not be packaged.
declare -Ax INSPIRCD_MODULE_WARNINGS=(
	["geo_maxmind"]="libmaxminddb's license (Apache 2.0) is not compatible with InspIRCd's (GPLv2)"
	["ssl_mbedtls"]="mbedTLS's license (Apache 2.0) is not compatible with InspIRCd's (GPLv2)"
	["ssl_openssl"]="OpenSSL's license (custom) is not compatible with InspIRCd's (GPLv2)"
)

# The directory the current script is in.
export INSPIRCD_ROOT_DIR=$(dirname $(readlink -f "${BASH_SOURCE[0]}"))

# The directory that packages are built in.
export INSPIRCD_BUILD_DIR="${INSPIRCD_ROOT_DIR}/build"
rm -fr ${INSPIRCD_BUILD_DIR}
mkdir -p ${INSPIRCD_BUILD_DIR}

# Build the packages.
for INSPIRCD_PACKAGE in ${INSPIRCD_PACKAGES}
do
	if [ -d "${INSPIRCD_ROOT_DIR}/${INSPIRCD_PACKAGE}" ]
	then
		source "${INSPIRCD_ROOT_DIR}/${INSPIRCD_PACKAGE}/host.sh"
	fi
done

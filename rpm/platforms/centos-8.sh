if [ -z "${INSPIRCD_ROOT_DIR}" ]
then
	>&2 echo 'This script should not be used directly!'
	exit 1
fi

export PLATFORM_NAME="CentOS 8"
export PLATFORM_CONTAINER="centos:8"

declare -Ax MODULE_BUILD_DEPS=(
	["geo_maxmind"]="libmaxminddb-devel pkgconfig"
	["ldap"]="openldap-devel"
	["mysql"]="mariadb-connector-c-devel"
	["pgsql"]="postgresql-devel"
	["regex_pcre"]="pcre-devel"
	["regex_posix"]=""
	["regex_stdlib"]=""
	["sqlite3"]="pkgconfig sqlite-devel"
	["ssl_gnutls"]="gnutls-devel pkgconfig"
	["ssl_openssl"]="openssl-devel pkgconfig"
	["sslrehashsignal"]=""
)

declare -Ax MODULE_RUNTIME_DEPS=(
	["geo_maxmind"]="libmaxminddb"
	["ldap"]="openldap"
	["mysql"]="mariadb-connector-c"
	["pgsql"]="postgresql-libs"
	["regex_pcre"]="pcre"
	["regex_posix"]=""
	["regex_stdlib"]=""
	["sqlite3"]="sqlite"
	["ssl_gnutls"]="gnutls"
	["ssl_openssl"]="openssl"
	["sslrehashsignal"]=""
)

declare -Ax MODULE_ERRORS=(
	["regex_re2"]="RE2 is not is not packaged by CentOS 8"
	["regex_tre"]="TRE is not is not packaged by CentOS 8"
	["ssl_mbedtls"]="mbedTLS is not packaged by CentOS 8"
)

declare -Ax MODULE_WARNINGS=(
	["geo_maxmind"]="libmaxminddb's license (Apache 2.0) is not compatible with InspIRCd's (GPLv2)"
	["ssl_mbedtls"]="mbedTLS's license (Apache 2.0) is not compatible with InspIRCd's (GPLv2)"
	["ssl_openssl"]="OpenSSL's license (custom) is not compatible with InspIRCd's (GPLv2)"
)

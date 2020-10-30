if [ -z "${INSPIRCD_ROOT_DIR}" ]
then
	>&2 echo 'This script should not be used directly!'
	exit 1
fi

export PLATFORM_NAME="CentOS 7"
export PLATFORM_CONTAINER="centos:7"

declare -Ax MODULE_BUILD_DEPS=(
	["geo_maxmind"]="libmaxminddb-devel pkgconfig"
	["ldap"]="openldap-devel"
	["mysql"]="mariadb-devel"
	["pgsql"]="postgresql-devel"
	["regex_pcre"]="pcre-devel"
	["regex_posix"]=""
	["sqlite3"]="pkgconfig sqlite-devel"
	["ssl_gnutls"]="gnutls-devel pkgconfig"
	["ssl_openssl"]="openssl-devel pkgconfig"
	["sslrehashsignal"]=""
)

declare -Ax MODULE_RUNTIME_DEPS=(
	["geo_maxmind"]="libmaxminddb"
	["ldap"]="openldap"
	["mysql"]="mariadb-libs"
	["pgsql"]="postgresql-libs"
	["regex_pcre"]="pcre"
	["regex_posix"]=""
	["sqlite3"]="sqlite"
	["ssl_gnutls"]="gnutls"
	["ssl_openssl"]="openssl"
	["sslrehashsignal"]=""
)

declare -Ax MODULE_ERRORS=(
	["argon2"]="Argon2 is not packaged by CentOS 7"
	["regex_re2"]="RE2 is not is not packaged by CentOS 7"
	["regex_stdlib"]="GCC 4.9 is required for std::regex support"
	["regex_tre"]="TRE is not is not packaged by CentOS 7"
	["ssl_mbedtls"]="mbedTLS is not packaged by CentOS 7"
)

declare -Ax MODULE_WARNINGS=()

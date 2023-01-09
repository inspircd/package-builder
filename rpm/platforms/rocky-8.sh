if [ -z "${INSPIRCD_ROOT_DIR}" ]
then
	>&2 echo 'This script should not be used directly!'
	exit 1
fi

export PLATFORM_NAME="Rocky Linux 8"
export PLATFORM_CONTAINER="rockylinux:8"

declare -Ax MODULE_BUILD_DEPS=(
	["geo_maxmind"]="libmaxminddb-devel pkgconfig"
	["ldap"]="openldap-devel"
	["mysql"]="mariadb-connector-c-devel"
	["pgsql"]="postgresql-devel"
	["regex_pcre"]="pcre-devel"
	["regex_pcre2"]="pcre2-devel"
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
	["regex_pcre2"]="pcre2"
	["regex_posix"]=""
	["regex_stdlib"]=""
	["sqlite3"]="sqlite"
	["ssl_gnutls"]="gnutls perl-IO-Socket-SSL"
	["ssl_openssl"]="openssl perl-IO-Socket-SSL"
	["sslrehashsignal"]=""
)

declare -Ax MODULE_ERRORS=(
	["argon2"]="Argon2 is not packaged by Rocky Linux 8"
	["regex_re2"]="RE2 is not is not packaged by Rocky Linux 8"
	["regex_tre"]="TRE is not is not packaged by Rocky Linux 8"
	["ssl_mbedtls"]="mbedTLS is not packaged by Rocky Linux 8"
)

declare -Ax MODULE_WARNINGS=()

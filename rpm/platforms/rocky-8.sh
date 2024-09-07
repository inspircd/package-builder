if [ -z "${INSPIRCD_ROOT_DIR}" ]
then
	>&2 echo 'This script should not be used directly!'
	exit 1
fi

export PLATFORM_NAME="Rocky Linux 8"
export PLATFORM_CONTAINER="rockylinux:8"

export CORE_BUILD_DEPS="libpsl-devel pkgconfig"
export CORE_RUNTIME_DEPS="libpsl publicsuffix-list"

declare -Ax MODULE_BUILD_DEPS=(
	["geo_maxmind"]="libmaxminddb-devel pkgconfig"
	["ldap"]="openldap-devel"
	["log_syslog"]=""
	["mysql"]="mariadb-connector-c-devel"
	["pgsql"]="postgresql-devel"
	["regex_pcre2"]="pcre2-devel"
	["regex_posix"]=""
	["sqlite3"]="pkgconfig sqlite-devel"
	["ssl_gnutls"]="gnutls-devel pkgconfig"
	["ssl_openssl"]="openssl-devel pkgconfig"
	["sslrehashsignal"]=""
)

declare -Ax MODULE_RUNTIME_DEPS=(
	["geo_maxmind"]="libmaxminddb"
	["ldap"]="openldap"
	["log_syslog"]=""
	["mysql"]="mariadb-connector-c"
	["pgsql"]="postgresql-libs"
	["regex_pcre2"]="pcre2"
	["regex_posix"]=""
	["sqlite3"]="sqlite"
	["ssl_gnutls"]="gnutls perl-IO-Socket-SSL"
	["ssl_openssl"]="openssl perl-IO-Socket-SSL"
	["sslrehashsignal"]=""
)

declare -Ax MODULE_ERRORS=(
	["argon2"]="Argon2 is not packaged by Rocky Linux 8"
	["log_json"]="yyjson is not packaged by Rocky Linux 8"
	["regex_re2"]="RE2 is not is not packaged by Rocky Linux 8"
)

declare -Ax MODULE_WARNINGS=()

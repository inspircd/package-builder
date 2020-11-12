if [ -z "${INSPIRCD_ROOT_DIR}" ]
then
	>&2 echo 'This script should not be used directly!'
	exit 1
fi

export PLATFORM_NAME="Debian 11 (Bullseye, Testing)"
export PLATFORM_CONTAINER="debian:bullseye"
export PLATFORM_SUFFIX="deb11u"

declare -Ax MODULE_BUILD_DEPS=(
	["argon2"]="libargon2-dev pkg-config"
	["geo_maxmind"]="libmaxminddb-dev pkg-config"
	["ldap"]="libldap2-dev"
	["mysql"]="libmariadb-dev libmariadb-dev-compat"
	["pgsql"]="libpq-dev"
	["regex_pcre"]="libpcre3-dev"
	["regex_posix"]=""
	["regex_re2"]="libre2-dev pkg-config"
	["regex_tre"]="libtre-dev pkg-config"
	["sqlite3"]="libsqlite3-dev pkg-config"
	["ssl_gnutls"]="libgnutls28-dev pkg-config"
	["ssl_mbedtls"]="libmbedtls-dev"
	["ssl_openssl"]="libssl-dev pkg-config"
	["sslrehashsignal"]=""
)

# Note: ${shlibs:Depends} takes care of runtime libraries.
declare -Ax MODULE_RUNTIME_DEPS=(
	["argon2"]=""
	["geo_maxmind"]=""
	["ldap"]=""
	["mysql"]=""
	["pgsql"]=""
	["regex_pcre"]=""
	["regex_posix"]=""
	["regex_re2"]=""
	["regex_tre"]=""
	["sqlite3"]=""
	["ssl_gnutls"]="gnutls-bin"
	["ssl_mbedtls"]=""
	["ssl_openssl"]="openssl"
	["sslrehashsignal"]=""
)

declare -Ax MODULE_ERRORS=()

declare -Ax MODULE_WARNINGS=()

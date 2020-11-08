if [ -z "${INSPIRCD_ROOT_DIR}" ]
then
	>&2 echo 'This script should not be used directly!'
	exit 1
fi

export PLATFORM_NAME="Ubuntu 18.04 (Bionic Beaver)"
export PLATFORM_CONTAINER="ubuntu:bionic"
export PLATFORM_SUFFIX="bionic"

declare -Ax MODULE_BUILD_DEPS=(
	["argon2"]="libargon2-0-dev pkg-config"
	["geo_maxmind"]="libmaxminddb-dev pkg-config"
	["ldap"]="libldap2-dev"
	["mysql"]="libmariadb-dev libmariadb-dev-compat libssl-dev"
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

declare -Ax MODULE_RUNTIME_DEPS=(
	["argon2"]="libargon2-0"
	["geo_maxmind"]="libmaxminddb0"
	["ldap"]="libldap-2.4-2"
	["mysql"]="libmariadb3 libssl1.1"
	["pgsql"]="libpq5"
	["regex_pcre"]="libpcre3"
	["regex_posix"]=""
	["regex_re2"]="libre2-4"
	["regex_tre"]="libtre5"
	["sqlite3"]="libsqlite3-0"
	["ssl_gnutls"]="gnutls-bin libgnutls30"
	["ssl_mbedtls"]="libmbedtls12"
	["ssl_openssl"]="libssl1.1 openssl"
	["sslrehashsignal"]=""
)

declare -Ax MODULE_ERRORS=()

declare -Ax MODULE_WARNINGS=(
	["mysql"]="OpenSSL's license (custom) is not compatible with InspIRCd's (GPLv2)"
)

if [ -z "${INSPIRCD_ROOT_DIR}" ]
then
	>&2 echo 'This script should not be used directly!'
	exit 1
fi

export PLATFORM_NAME="Ubuntu 24.04 (Noble Numbat)"
export PLATFORM_CONTAINER="ubuntu:noble"
export PLATFORM_SUFFIX="ubuntu24.04."

export CORE_BUILD_DEPS="libpsl-dev pkg-config"
export CORE_RUNTIME_DEPS="publicsuffix"

declare -Ax MODULE_BUILD_DEPS=(
	["argon2"]="libargon2-dev pkg-config"
	["geo_maxmind"]="libmaxminddb-dev pkg-config"
	["ldap"]="libldap2-dev"
	["log_json"]="rapidjson-dev"
	["log_syslog"]=""
	["mysql"]="default-libmysqlclient-dev"
	["pgsql"]="libpq-dev"
	["regex_pcre2"]="libpcre2-dev pkg-config"
	["regex_posix"]=""
	["regex_re2"]="libre2-dev pkg-config"
	["sqlite3"]="libsqlite3-dev pkg-config"
	["ssl_gnutls"]="libgnutls28-dev pkg-config"
	["ssl_openssl"]="libssl-dev pkg-config"
	["sslrehashsignal"]=""
)

# Note: ${shlibs:Depends} takes care of runtime libraries.
declare -Ax MODULE_RUNTIME_DEPS=(
	["argon2"]=""
	["geo_maxmind"]=""
	["ldap"]=""
	["log_json"]=""
	["log_syslog"]=""
	["mysql"]=""
	["pgsql"]=""
	["regex_pcre2"]=""
	["regex_posix"]=""
	["regex_re2"]=""
	["sqlite3"]=""
	["ssl_gnutls"]="gnutls-bin libio-socket-ssl-perl"
	["ssl_openssl"]="libio-socket-ssl-perl openssl"
	["sslrehashsignal"]=""
)

declare -Ax MODULE_ERRORS=()

declare -Ax MODULE_WARNINGS=()

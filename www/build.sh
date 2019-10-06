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

RUBY=${RUBY:=ruby}
if ! ${RUBY} --version 1>/dev/null 2>/dev/null
then
	echo 'Skipping the web interface because Ruby is not installed.'
	return
fi

${RUBY} "${INSPIRCD_ROOT_DIR}/www/build.rb"

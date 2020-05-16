if [ -z "${INSPIRCD_ROOT_DIR}" ]
then
	>&2 echo 'This script should not be used directly!'
	exit 1
fi

echo 'Building the RPM packages ...'

# The path to the the RPM .spec file.
SPECFILE="${INSPIRCD_ROOT_DIR}/rpm/inspircd.spec"

# Build the RPM packages.
for PLATFORM in ${INSPIRCD_ROOT_DIR}/rpm/platforms/*.sh
do
	# Work out what we actually need to do.
	source ${PLATFORM}
	for INSPIRCD_MODULE in ${INSPIRCD_MODULES}
	do
		if [ "${MODULE_ERRORS[${INSPIRCD_MODULE}]+isdef}" ]
		then
			>&2 echo "Unable to enable ${INSPIRCD_MODULE} because ${MODULE_ERRORS[${INSPIRCD_MODULE}]}!"
			[ -z "${INSPIRCD_MODULES_DEFAULT}" ] && exit 1
		elif [ "${MODULE_WARNINGS[${INSPIRCD_MODULE}]+isdef}" -a -z "${INSPIRCD_IGNORE_WARNINGS}" ]
		then
			>&2 echo "Unable to enable ${INSPIRCD_MODULE} because ${MODULE_WARNINGS[${INSPIRCD_MODULE}]}!"
			if [ -z "${INSPIRCD_MODULES_DEFAULT}" ]
			then
				>&2 echo "Set INSPIRCD_IGNORE_WARNINGS=1 to ignore this warning!"
				exit 1
			fi
		elif [ "${MODULE_BUILD_DEPS[${INSPIRCD_MODULE}]+isdef}" -a "${MODULE_RUNTIME_DEPS[${INSPIRCD_MODULE}]+isdef}" ]
		then
			RPM_BUILD_DEPS="${RPM_BUILD_DEPS} ${MODULE_BUILD_DEPS[${INSPIRCD_MODULE}]}"
			RPM_RUNTIME_DEPS="${RPM_RUNTIME_DEPS} ${MODULE_RUNTIME_DEPS[${INSPIRCD_MODULE}]}"
			RPM_MODULES="${RPM_MODULES} ${INSPIRCD_MODULE}"
		elif [ -z "${INSPIRCD_MODULES_DEFAULT}" ]
		then
			>&2 echo "${INSPIRCD_MODULE} is not a module supported by this build script!"
			exit 1
		fi
	done

	# Remove duplicate packages.
	RPM_BUILD_DEPS=`echo ${RPM_BUILD_DEPS} | sort -u`
	RPM_RUNTIME_DEPS=`echo ${RPM_RUNTIME_DEPS} | sort -u`

	# Create the specfile for this platform.
	cp -f "${SPECFILE}.in" ${SPECFILE}
	sed -i "s/@@INSPIRCD_VERSION@@/${INSPIRCD_VERSION}/g" ${SPECFILE}
	sed -i "s/@@INSPIRCD_REVISION@@/${INSPIRCD_REVISION}/g" ${SPECFILE}
	sed -i "s/@@RPM_BUILD_DEPS@@/${RPM_BUILD_DEPS}/g" ${SPECFILE}
	sed -i "s/@@RPM_RUNTIME_DEPS@@/${RPM_RUNTIME_DEPS}/g" ${SPECFILE}
	sed -i "s/@@RPM_MODULES@@/${RPM_MODULES}/g" ${SPECFILE}

	# Actually build the package.
	echo "Building the RPM package for ${PLATFORM_NAME} ..."
	docker pull ${PLATFORM_CONTAINER}
	docker run --rm \
		-e "DISTRO_NAME=${PLATFORM_NAME}" \
		-e "DISTRO_PACKAGES=${RPM_BUILD_DEPS}" \
		-v "${INSPIRCD_ROOT_DIR}/rpm:/root/sources" \
		-v "${INSPIRCD_BUILD_DIR}:/root/packages" \
		-w '/root' \
		${PLATFORM_CONTAINER} \
		'/root/sources/docker.sh'

	# Clean up for the next run.
	unset PLATFORM_NAME PLATFORM_CONTAINER MODULE_BUILD_DEPS MODULE_RUNTIME_DEPS MODULE_ERRORS MODULE_WARNINGS
	unset RPM_BUILD_DEPS RPM_RUNTIME_DEPS RPM_MODULES
	rm -f ${SPECFILE}
done

# Clean out the garbage.
rm -f ${SPECFILE}

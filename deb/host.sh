if [ -z "${INSPIRCD_ROOT_DIR}" ]
then
	>&2 echo 'This script should not be used directly!'
	exit 1
fi

echo 'Building the deb packages ...'

# Build the deb packages.
for PLATFORM in ${INSPIRCD_ROOT_DIR}/deb/platforms/*.sh
do
	# Work out what we actually need to do.
	source ${PLATFORM}

	# Combine the platform warnings with the global warnings.
	for INSPIRCD_MODULE_WARNING in "${!INSPIRCD_MODULE_WARNINGS[@]}"
	do
		MODULE_WARNINGS[${INSPIRCD_MODULE_WARNING}]=${INSPIRCD_MODULE_WARNINGS[${INSPIRCD_MODULE_WARNING}]}
	done

	# Attempt to enable all of the requested modules.
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
			DEB_BUILD_DEPS="${DEB_BUILD_DEPS} ${MODULE_BUILD_DEPS[${INSPIRCD_MODULE}]}"
			DEB_RUNTIME_DEPS="${DEB_RUNTIME_DEPS} ${MODULE_RUNTIME_DEPS[${INSPIRCD_MODULE}]}"
			DEB_MODULES="${DEB_MODULES} ${INSPIRCD_MODULE}"
		elif [ -z "${INSPIRCD_MODULES_DEFAULT}" ]
		then
			>&2 echo "${INSPIRCD_MODULE} is not a module supported by this build script!"
			exit 1
		fi
	done

	# Remove duplicate packages.
	DEB_BUILD_DEPS=`echo ${DEB_BUILD_DEPS} | sort -u`
	DEB_RUNTIME_DEPS=`echo ${DEB_RUNTIME_DEPS} | sort -u`

	# Create the package files for this platform.
	DEB_PACKAGE="${INSPIRCD_ROOT_DIR}/deb/debian"
	mkdir -p ${DEB_PACKAGE}
	for INFILE in ${INSPIRCD_ROOT_DIR}/deb/files/*.in
	do
		FILE=${DEB_PACKAGE}/$(basename ${INFILE} .in)
		cp -f ${INFILE} ${FILE}
		sed -i "s/@@INSPIRCD_VERSION@@/${INSPIRCD_VERSION}/g" ${FILE}
		sed -i "s/@@INSPIRCD_REVISION@@/${INSPIRCD_REVISION}/g" ${FILE}
		sed -i "s/@@PLATFORM_SUFFIX@@/${PLATFORM_SUFFIX}/g" ${FILE}
		sed -i "s/@@DEB_BUILD_STAMP@@/$(date -Ru)/g" ${FILE}
		sed -i "s/@@DEB_BUILD_DEPS@@/${DEB_BUILD_DEPS}/g" ${FILE}
		sed -i "s/@@DEB_BUILD_DEPS_COMMA@@/${DEB_BUILD_DEPS// /,}/g" ${FILE}
		sed -i "s/@@DEB_RUNTIME_DEPS@@/${DEB_RUNTIME_DEPS}/g" ${FILE}
		sed -i "s/@@DEB_RUNTIME_DEPS_COMMA@@/${DEB_RUNTIME_DEPS// /,}/g" ${FILE}
		sed -i "s/@@DEB_MODULES@@/${DEB_MODULES}/g" ${FILE}
	done

	# Actually build the package.
	echo "Building the deb package for ${PLATFORM_NAME} ..."
	docker pull ${PLATFORM_CONTAINER}
	docker run --rm \
		-e "DISTRO_NAME=${PLATFORM_NAME}" \
		-e "DISTRO_PACKAGES=${DEB_BUILD_DEPS}" \
		-e "INSPIRCD_VERSION=${INSPIRCD_VERSION}" \
		-v "${INSPIRCD_ROOT_DIR}/deb:/root/sources" \
		-v "${INSPIRCD_BUILD_DIR}:/root/packages" \
		-w '/root' \
		${PLATFORM_CONTAINER} \
		'/root/sources/docker.sh'

	# Clean up for the next run.
	unset PLATFORM_NAME PLATFORM_CONTAINER PLATFORM_SUFFIX MODULE_BUILD_DEPS MODULE_RUNTIME_DEPS MODULE_ERRORS MODULE_WARNINGS
	unset DEB_BUILD_DEPS DEB_RUNTIME_DEPS DEB_MODULES
done

# Clean out the garbage.
rm -f ${DEB_PACKAGE}

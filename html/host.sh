if [ -z "${INSPIRCD_ROOT_DIR}" ]
then
	>&2 echo 'This script should not be used directly!'
	exit 1
fi

echo 'Building the web interface ...'

# Build the web interface.
docker pull ruby:slim
docker run --rm \
	-v "${INSPIRCD_ROOT_DIR}/html:/root/sources" \
	-v "${INSPIRCD_BUILD_DIR}:/root/packages" \
	-w '/root' \
	ruby:slim \
	'/root/sources/docker.rb'

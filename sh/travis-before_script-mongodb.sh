#!/usr/bin/env bash

# Install MongoDB
MONGODB_DIR="${HOME}/mongodb"

# Setup mongodb cache
if [ ! -d "${MONGODB_DIR}" ]; then
    mkdir -p "${MONGODB_DIR}"
fi

MONGODB_HOME="${MONGODB_DIR}/mongodb-linux-x86_64-${MONGODB_VERSION}"
MONGODB_TGZ="${MONGODB_DIR}/mongodb-linux-x86_64-${MONGODB_VERSION}.tgz"
MONGODB_DL_URL="http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-${MONGODB_VERSION}.tgz"

if [ ! -d "${MONGODB_HOME}" ]; then
    wget "${MONGODB_DL_URL}" -O "${MONGODB_TGZ}"
    tar -xvf "${MONGODB_TGZ}" -C "${MONGODB_DIR}"
    rm "${MONGODB_TGZ}"
else
    echo "MongoDB already downloaded to ${MONGODB_HOME}"
fi

# Run MongoDB
MONGOD_BIN="${MONGODB_HOME}/bin/mongod"

mkdir -p /tmp/data
echo "Starting MongoDB $(${MONGOD_BIN} --version)"
${MONGOD_BIN} --config "${CONFIG}" &> /dev/null &

#!/bin/bash
# Copyright opyright (c) Huawei Technologies Co., Ltd. 2010-2018. All rights reserved.
# description: the script that make install boost
# date: 2020-11-20
# version: 1.72.0
# history: new version update

set -e

######################################################################
# Parameter setting
######################################################################
LOCAL_PATH=${0}
FIRST_CHAR=$(expr substr "$LOCAL_PATH" 1 1)
if [ "$FIRST_CHAR" = "/" ]; then
    LOCAL_PATH=${0}
else
    LOCAL_PATH="$(pwd)/${LOCAL_PATH}"
fi

LOCAL_DIR=$(dirname "${LOCAL_PATH}")
CONFIG_FILE_NAME=config.ini
BUILD_OPTION=release

TAR_FILE_NAME=boost_1_72_0.tar.gz
SOURCE_CODE_PATH=boost_1_72_0

LOG_FILE=${LOCAL_DIR}/build_boost.log
BUILD_FAILED=1

ls ${LOCAL_DIR}/${CONFIG_FILE_NAME} >/dev/null 2>&1
if [ $? -ne 0 ]; then
        die "[Error] the file ${CONFIG_FILE_NAME} not exist."
fi

COMPLIE_TYPE_LIST=$(cat ${LOCAL_DIR}/${CONFIG_FILE_NAME} | grep -v '#' | grep -v '^$' | awk -F '=' '{print $2}' | sed  's/|/ /g')
COMPONENT_NAME=$(cat ${LOCAL_DIR}/${CONFIG_FILE_NAME} | grep -v '#' | grep -v '^$' |awk -F '=' '{print $1}'| awk -F '@' '{print $2}')
COMPONENT_TYPE=$(cat ${LOCAL_DIR}/${CONFIG_FILE_NAME} | grep -v '#' | grep -v '^$' | awk -F '@' '{print $1}')
PLAT_FORM_STR=$(sh ${LOCAL_DIR}/../../build/get_PlatForm_str.sh)

if [ "${PLAT_FORM_STR}"X = "Failed"X ]
then
        die "[Error] the plat form is not supported!"
fi

if [ "${COMPONENT_NAME}"X = ""X ]
then
        die "[Error] get component name failed!"
fi

if [ "${COMPONENT_TYPE}"X = ""X ]
then
        die "[Error] get component type failed!"
fi


ROOT_DIR="${LOCAL_DIR}/../../"
INSTALL_COMPOENT_PATH_NAME="${ROOT_DIR}/output/dependency/${PLAT_FORM_STR}/${COMPONENT_NAME}"


#######################################################################
## print help information
#######################################################################
function print_help()
{
    echo "Usage: $0 [OPTION]
    -h|--help               show help information
    -m|--build_option       provode type of operation, values of paramenter is build, shrink, dist or clean
    "
}

#######################################################################
#  Print log.
#######################################################################
log()
{
    echo "[Build boost] $(date +%y-%m-%d' '%T): $@"
    echo "[Build boost] $(date +%y-%m-%d' '%T): $@" >> "$LOG_FILE" 2>&1
}

#######################################################################
#  print log and exit.
#######################################################################
die()
{
    log "$@"
    echo "$@"
    exit $BUILD_FAILED
}


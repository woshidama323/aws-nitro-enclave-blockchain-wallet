#!/usr/bin/env bash
#  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#  SPDX-License-Identifier: MIT-0

set +x
set -e

KMS_FOLDER=./application/eth1/enclave/kms
KMSTOOL_FOLDER=./aws-nitro-enclaves-sdk-c/bin/kmstool-enclave-cli
KMSTOOL_NEW_FOLDER=./aws-nitro-enclaves-sdk-c/bin/kmstool-enclave-new-cli
if [[ ! -d ${KMS_FOLDER} ]]; then
  mkdir -p ${KMS_FOLDER}
fi

if [[ ! -d ${KMSTOOL_NEW_FOLDER} ]]; then
  mkdir -p ${KMSTOOL_NEW_FOLDER}
fi


# delete repo if already there or if folder exists
rm -rf ${KMS_FOLDER}/aws-nitro-enclaves-sdk-c

cd ${KMS_FOLDER}
git clone https://github.com/woshidama323/aws-nitro-enclaves-sdk-c.git

# if in corporate network execute
cd ./aws-nitro-enclaves-sdk-c/containers
awk 'NR==1{print; print "ARG GOPROXY=direct"} NR!=1' Dockerfile.al2 > Dockerfile.al2_new
mv Dockerfile.al2_new Dockerfile.al2
cd ../../

cd ${KMSTOOL_FOLDER}
./build.sh
cp ./kmstool_enclave_cli ../../../kmstool_enclave_cli
cp ./libnsm.so ../../../libnsm.so
cd - 

cd ${KMSTOOL_NEW_FOLDER}
./build.sh
cp ./kmstool_enclave_new_cli ../../../kmstool_enclave_new_cli
cd -

rm -rf ./aws-nitro-enclaves-sdk-c

echo "kmstool_enclave_cli build successful"
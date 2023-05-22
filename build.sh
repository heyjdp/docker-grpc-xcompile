#!/usr/bin/env bash

pushd /var/local/git/grpc/test/distrib/cpp/
./build_code_dir_aarch64_cross.sh $1
popd

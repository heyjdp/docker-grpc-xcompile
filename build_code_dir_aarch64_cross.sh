#!/usr/bin/env bash

set -ex

cd "$(dirname "$0")/../../.."

# Use externally provided env to determine build parallelism, otherwise use default.
GRPC_CPP_DISTRIBTEST_BUILD_COMPILER_JOBS=${GRPC_CPP_DISTRIBTEST_BUILD_COMPILER_JOBS:-12}

echo Building in: $1

# Build the $1 code directory for the host architecture.
mkdir -p "examples/cpp/"$1"/cmake/build"
pushd "examples/cpp/"$1"/cmake/build"
cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DgRPC_INSTALL=ON \
  -DgRPC_BUILD_TESTS=OFF \
  -DgRPC_SSL_PROVIDER=package \
  ../..
make "-j${GRPC_CPP_DISTRIBTEST_BUILD_COMPILER_JOBS}"
popd

# Build the $1 code directory example for ARM.
# As above, it will find and use protoc and grpc_cpp_plugin
# for the host architecture.
mkdir -p "examples/cpp/"$1"/cmake/build_arm"
pushd "examples/cpp/"$1"/cmake/build_arm"
cmake -DCMAKE_TOOLCHAIN_FILE=/tmp/toolchain.cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -Dabsl_DIR=/tmp/stage/lib/cmake/absl \
      -DProtobuf_DIR=/tmp/stage/lib/cmake/protobuf \
      -DgRPC_DIR=/tmp/stage/lib/cmake/grpc \
      ../..
make "-j${GRPC_CPP_DISTRIBTEST_BUILD_COMPILER_JOBS}"
popd

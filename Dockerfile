# syntax=docker/dockerfile:1

## Build the gRPC code cross-compile builder with (important: note the dot at the end):
## 
## docker build -t docker-grpc-xcompile . 
## 
## And rememeber to run with: -v $(pwd)/<code_dir>:/var/local/git/grpc/examples/cpp/<code_dir>
## for example:
## 
## docker run --rm -v $(pwd)/helloworld:/var/local/git/grpc/examples/cpp/helloworld -it docker-grpc-xcompile /build.sh helloworld
##
## You will find your compiled binaries in:
##
## x86_64  -> <code_dir>/cmake/build
## aarch64 -> <code_dir>/cmake/build_arm
##

FROM debian:11-slim

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt install -y \
      build-essential \
      autoconf \
      libtool \
      pkg-config \
      git \
      cmake \
      gcc-aarch64-linux-gnu \
      g++-aarch64-linux-gnu \
      binutils-aarch64-linux-gnu \
      && \
    rm -rf /var/lib/apt/lists/*

ENV GRPC_RELEASE_TAG v1.52.0

RUN git clone --recurse-submodules \
    -b ${GRPC_RELEASE_TAG} --depth 1 \
    --shallow-submodules \
    https://github.com/grpc/grpc \
    /var/local/git/grpc

COPY build_cmake_grpc_aarch64_cross.sh /var/local/git/grpc/test/distrib/cpp/

RUN cd /var/local/git/grpc/test/distrib/cpp \
  && chmod +x build_cmake_grpc_aarch64_cross.sh \
  && ./build_cmake_grpc_aarch64_cross.sh

COPY build_code_dir_aarch64_cross.sh /var/local/git/grpc/test/distrib/cpp/

RUN cd /var/local/git/grpc/test/distrib/cpp \
  && chmod +x build_code_dir_aarch64_cross.sh

COPY ./build.sh / 
RUN chmod +x /build.sh

CMD ["/bin/bash"]

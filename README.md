# Docker gRPC X-Compiler

For when you need to cross compile c/c++ with gRPC for both x86_64 and aarch64

Do this:

1. Change the contents of `grpc-simple-demo` directory to contain the code you want

2. Create a Docker for the builds:

```
docker build -t docker-grpc-xcompile .
```

**NOTE**: this will take a while as it build all of gRPC for both platforms from scratch

3. Now we can compile and cross-compile our code:

```
docker run --rm -v $(pwd)/grpc-simple-demo:/var/local/git/grpc/examples/cpp/grpc-simple-demo -it docker-grpc-xcompile /build.sh grpc-simple-demo
```

**NOTE** the name of the directory is there ^^ three times, I just wanted it working, I didn't develop it too far, you need to change all three to the name of the directory you are building.

4. Your binaries will be in the directory `grpc-simple-demo/cmake/build` and `grpc-simple-demo/cmake/build_arm`


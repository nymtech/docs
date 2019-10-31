---
title: "Installation"
weight: 20
---

The mixnet code is relatively simple to build and run on Mac OS X and Linux. We haven't tried it on Windows (yet).

### Requirements

* Go 1.12 or later
* `make`
* `git`

To download and build:

```shell
git clone https://github.com/nymtech/nym-mixnet.git
cd nym-mixnet
git checkout v0.2.1
make
```

{{% notice tip %}}
In case you've been traumatized by Go's (lack of) dependency management in the past, you don't need to worry about `$GOPATH`, `$GOROOT` etc. Check the code out and build it wherever you want to.
{{% /notice %}}


Output should look like this:

```
nym-mixnet$ make
make build_client
make[1]: Entering directory '/home/dave/Desktop/foo/nym-mixnet'
mkdir -p build
go build -o build/loopix-client ./cmd/loopix-client
make[1]: Leaving directory '/home/dave/Desktop/foo/nym-mixnet'
make build_mixnode
make[1]: Entering directory '/home/dave/Desktop/foo/nym-mixnet'
mkdir -p build
go build -o build/loopix-mixnode ./cmd/loopix-mixnode
make[1]: Leaving directory '/home/dave/Desktop/foo/nym-mixnet'
make build_provider
make[1]: Entering directory '/home/dave/Desktop/foo/nym-mixnet'
mkdir -p build
go build -o build/loopix-provider ./cmd/loopix-provider
make[1]: Leaving directory '/home/dave/Desktop/foo/nym-mixnet'
make build_bench_client
make[1]: Entering directory '/home/dave/Desktop/foo/nym-mixnet'
mkdir -p build
go build -o build/bench-loopix-client ./cmd/bench-loopix-client
make[1]: Leaving directory '/home/dave/Desktop/foo/nym-mixnet'
make build_bench_provider
make[1]: Entering directory '/home/dave/Desktop/foo/nym-mixnet'
mkdir -p build
go build -o build/bench-loopix-provider ./cmd/bench-loopix-provider
make[1]: Leaving directory '/home/dave/Desktop/foo/nym-mixnet'
```

The above commands will check the code out from Github, and then compile six pieces of software into the `build/` directory:

```shell
nym-mixnet$ ls build/

bench-loopix-client  bench-loopix-provider  loopix-client  loopix-mixnode  loopix-provider
```

Forget about the `bench-loopix-*` ones for the moment, those are for performance testing. The interesting ones for us right now are:

1. the Nym mixnet client, `loopix-client`
1. the Nym mixnode, `loopix-mixnode`
1. the Nym storage node, `loopix-provider`

In the next sections we'll try each of these out.

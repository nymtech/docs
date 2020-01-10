---
title: "Installation"
weight: 20
---

The mixnet code is relatively simple to build and run on Mac OS X and Linux. We haven't tried it on Windows (yet).

### Requirements

* [Rust](https://www.rust-lang.org/) 1.39 or later, with Cargo. Stable works.


To download and build:

```shell
git clone https://github.com/nymtech/nym.git
cd nym
cargo test # runs unit and integration tests
cargo build --release # if you want binaries to try out
```

The above commands will check the code out from Github, and then compile three pieces of software into the `target/release` directory:

```shell
ls target/release/

build	     libnym_client.d		    nym-client	   nym-sfw-provider
deps	     libnym_client.rlib		    nym-client.d   nym-sfw-provider.d
examples     libsfw_provider_requests.d     nym-mixnode
incremental  libsfw_provider_requests.rlib  nym-mixnode.d

```

Quite a bit of stuff gets built, but you can ignore most of it. The mixnet parts are:

1. the Nym mixnode, `nym-mixnode`
1. the Nym store-and-forward provider node, `nym-sfw-provider`
1. the Nym client, `nym-client`

In the next sections we'll try each of these out.

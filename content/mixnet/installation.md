---
title: "Installation"
weight: 20
description: "How to build the Nym platform. Nym is relatively simple to build and run on Mac OS X, Linux, and Windows.
"
---

The mixnet code is relatively simple to build and run on Mac OS X and Linux. We also have initial Windows support but it should be considered (for now) even more experimental than the rest of our code.

### Requirements

* on Debian/Ubuntu: `sudo apt install pkg-config build-essential libssl-dev`. If you are averse to running the Rust shell script installer,  you *may* want to install `cargo` from `apt`. It might work, or might be too ancient, depending on your distro. 
* [Rust](https://www.rust-lang.org/) 1.39 or later, with `cargo`. Stable works. 

To download and build:

```shell
git clone https://github.com/nymtech/nym.git
cd nym
git pull # in case you've checked it out before!
git checkout tags/v0.5.0 # <-- **VERY IMPORTANT**
cargo build --release
```

**Note:** the default branch you'll clone from Github, `develop`, is guaranteed to be broken and incompatible with the running testnet at all times. You **must** `git checkout tags/v0.5.0` in order to join the testnet.

The above commands will compile into the `target/release` directory.

```shell
ls target/release/

build	     libnym_client.d		    nym-client	   nym-sfw-provider
deps	     libnym_client.rlib		    nym-client.d   nym-sfw-provider.d
examples     libsfw_provider_requests.d     nym-mixnode
incremental  libsfw_provider_requests.rlib  nym-mixnode.d

```

Quite a bit of stuff gets built, but you can ignore most of it. The mixnet parts are:

1. the Nym mixnode, `nym-mixnode`
2. the Nym store-and-forward provider node, `nym-sfw-provider`
3. the Nym client, `nym-client`

In the next sections we'll try each of these out.

---
title: "Building Nym"
weight: 20
description: "How to build the Nym platform. Nym is relatively simple to build and run on Mac OS X, Linux, and Windows."
---

{{% notice info %}}
This page details how to build the main Nym platform code, in Rust. **If you want to build and run a validator, [go here](/docs/run-nym-nodes/validators) instead.**
{{% /notice %}}

Nym runs on Mac OS X, Linux, and Windows. Windows should be considered experimental - it works fine if you're an app developer but isn't recommended for running nodes.

Prerequisites:

* on Debian/Ubuntu: `sudo apt install pkg-config build-essential libssl-dev curl jq`. 
* Rust **1.47 or later**, with `cargo`. Stable works. 

We recommend using the [Rust shell script installer](https://www.rust-lang.org/tools/install). Installing cargo from your package manager (e.g. `apt`) is not recommended as the packaged versions are usually too old.

If you really don't want to use the shell script installer, the [Rust installation docs](https://forge.rust-lang.org/infra/other-installation-methods.html) contain instructions for many platforms.

To download and build the Nym platform (mixnode, gateway and clients):

```
rustup update
git clone https://github.com/nymtech/nym.git
cd nym
git reset --hard # in case you made any changes on your branch
git pull # in case you've checked it out before
#
# Note: the default branch you clone from Github, `develop`, is guaranteed to be
# broken and incompatible with the running testnet at all times. You *must*
# `git checkout tags/v0.9.2` in order to join the testnet.
#
git checkout tags/v0.9.2
cargo build --release
```

The above commands will compile binaries into the `nym/target/release` directory.

Quite a bit of stuff gets built. The key working parts are:

1. the [mixnode](/docs/run-nym-nodes/mixnodes): `nym-mixnode`
2. the [gateway node](/docs/run-nym-nodes/gateways): `nym-gateway`
3. the [websocket client](/docs/build-apps/websocket-client): `nym-client`
4. the [socks5 client](/docs/use-apps/): `nym-socks5-client`
5. the [network requester](/docs/run-nym-nodes/requester): `nym-network-requester`

{{% notice info %}}
If you run into trouble, please ask for help in the channel **nymtech.friends#general** on [KeyBase](https://keybase.io).
{{% /notice %}}
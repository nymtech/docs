---
title: "Building Nym"
weight: 20
description: "How to build the Nym platform. Nym is relatively simple to build and run on Mac OS X, Linux, and Windows."
---

### Building the Nym platform

{{% notice info %}}
This page details how to build the main Nym platform code, in Rust. **If you want to build and run a validator, [go here](/docs/validators) instead.**
{{% /notice %}}

Nym is relatively simple to build and run on Mac OS X, Linux, and Windows. Windows should be considered experimental. Windows works fine if you're an app developer but isn't recommended for running nodes.

Prerequisites:

* on Debian/Ubuntu: `sudo apt install pkg-config build-essential libssl-dev`. 
* Rust **1.47 or later**, with `cargo`. Stable works. 

We recommend using the [Rust shell script installer](https://www.rust-lang.org/tools/install). Installing cargo from your package manager (e.g. `apt`) is not recommended as the packaged versions are usually too old.

If you really don't want to use the shell script installer, the [Rust installation docs](https://forge.rust-lang.org/infra/other-installation-methods.html) contain instructions for many platforms.

To download and build the Nym platform (mixnode, gateway and clients):

```shell
rustup update
git clone https://github.com/nymtech/nym.git
cd nym
git pull # in case you've checked it out before
git checkout tags/v0.9.0 # <-- **VERY IMPORTANT**
cargo build --release
```

**Upgrade note:** If you are upgrading to 0.9.0 from a 0.8.x release, you can use the `update` command to upgrade your configurations in place without touching your existing keys.

**Note:** the default branch you'll clone from Github, `develop`, is guaranteed to be broken and incompatible with the running testnet at all times. You **must** `git checkout tags/v0.9.0` in order to join the testnet.

The above commands will compile into the `target/release` directory.

Quite a bit of stuff gets built. The key working parts are:

1. the [Nym mixnode](/docs/run-nym-nodes/mixnodes), `nym-mixnode`
2. the [Nym gateway node](/docs/run-nym-nodes/gateways), `nym-gateway`
3. the [Nym websocket client](/docs/privacy-apps/websocket-client), `nym-client`
4. the [Nym socks5 client](/docs/privacy-apps/socks-client), `nym-socks5-client`
5. the [Nym network requester](/docs/run-nym-nodes/requester), `nym-network-requester`

You can try some of them out quickly by following along in the next few sections.

{{% notice info %}}
If you run into trouble, please ask for help in the channel **nymtech.friends#general** on [KeyBase](https://keybase.io).
{{% /notice %}}
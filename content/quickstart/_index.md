---
title: "Quickstart"
weight: 15
description: "How to build the Nym platform. Nym is relatively simple to build and run on Mac OS X, Linux, and Windows."
---

### Installing pre-built binaries

The Nym release page at [https://github.com/nymtech/nym/releases](https://github.com/nymtech/nym/releases) has pre-built binaries for some components. These are not guaranteed to work on all systems. 

Later, when we're focused more on things like packaging, we will ensure that all components get built for all operating systems. 

If the pre-built binaries don't work or are unavailable for your system, you will need to build the platform yourself.

### Building the Nym platform

Nym is relatively simple to build and run on Mac OS X, Linux, and Windows.

Windows support should be considered experimental. Windows currently works fine if you're a Peap developer but isn't recommended for running nodes.

* on Debian/Ubuntu: `sudo apt install pkg-config build-essential libssl-dev`. 
* Rust **1.47 or later**, with `cargo`. Stable works. 

We recommend using the [Rust shell script installer](https://www.rust-lang.org/tools/install). Installing cargo from your package manager (e.g. `apt`) is not recommended as the packaged versions are usually too old.

If you really don't want to use the shell script installer, the [Rust installation docs](https://forge.rust-lang.org/infra/other-installation-methods.html) contain instructions for many platforms.

To download and build:

```shell
rustup update
git clone https://github.com/nymtech/nym.git
cd nym
git pull # in case you've checked it out before
git checkout tags/v0.8.1 # <-- **VERY IMPORTANT**
cargo build --release
```

**Upgrade note:** If you are upgrading to 0.8.1 from a 0.7.0 or earlier release, you will need to [re-initialize your mixnode](/docs/quickstart/run-a-mixnode), and any old clients you have, as the config file formats have changed significantly between releases.

**Note:** the default branch you'll clone from Github, `develop`, is guaranteed to be broken and incompatible with the running testnet at all times. You **must** `git checkout tags/v0.8.1` in order to join the testnet.

The above commands will compile into the `target/release` directory.

Quite a bit of stuff gets built, but you can ignore most of it. The key working parts are:

1. the Nym mixnode, `nym-mixnode`
2. the Nym gateway node, `nym-gateway`
3. the Nym native client, `nym-client`
4. the Nym socks5 client, `nym-socks5-client`
5. SphinxSocks, the anonymous network requester, `sphinx-socks`

You can try some of them out quickly by following along in the next few sections.

{{% notice info %}}
If you run into trouble, please ask for help in the channel **nymtech.friends#general** on [KeyBase](https://keybase.io).
{{% /notice %}}
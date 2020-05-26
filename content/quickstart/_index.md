---
title: "Quickstart"
weight: 15
description: "How to build the Nym platform. Nym is relatively simple to build and run on Mac OS X, Linux, and Windows.
"
---

Nym is relatively simple to build and run on Mac OS X and Linux. 

We also have initial Windows support, but it should be considered experimental and unsupported for now. Windows currently works fine if you're a PEApp developer but isn't recommended for running nodes.

### Prerequisites

* on Debian/Ubuntu: `sudo apt install pkg-config build-essential libssl-dev`. 
* [Rust](https://www.rust-lang.org/) 1.39 or later, with `cargo`. Stable works. 

{{% notice info %}}
Nym developers use the Rust shell script for development installation for platform development, which gives a full build environment. If you are averse to running the shell script installer,  you *may* want to install `cargo` from your package manager (e.g. `apt`). It might work, or might be too ancient, depending on your distro. Have a look at the Rust website docs to find an installation option that suits you.
{{% /notice %}}

To download and build:

```shell
git clone https://github.com/nymtech/nym.git
cd nym
git pull # in case you've checked it out before!
git checkout tags/v0.7.0 # <-- **VERY IMPORTANT**
cargo build --release
```

**Note:** the default branch you'll clone from Github, `develop`, is guaranteed to be broken and incompatible with the running testnet at all times. You **must** `git checkout tags/v0.7.0` in order to join the testnet. 

The above commands will compile into the `target/release` directory.

Quite a bit of stuff gets built, but you can ignore most of it. The key working parts are:

1. the Nym mixnode, `nym-mixnode`
2. the Nym gateway node, `nym-gateway`
3. the Nym local client, `nym-client`
4. the Nym validator, `nym-validator`

You can try some of them out quickly by following along in 

{{% notice info %}}
If you run into trouble, please ask for help in the channel **nymtech.friends#general** on [KeyBase](https://keybase.io).
{{% /notice %}}
---
title: "Run Nym Nodes"
weight: 15
description: "How to build the Nym platform. Nym is relatively simple to build and run on Mac OS X, Linux, and Windows."
---

### Installing pre-built binaries

The Nym release page at [https://github.com/nymtech/nym/releases](https://github.com/nymtech/nym/releases) has pre-built binaries which should work on Ubuntu 20.04. These are not guaranteed to work on all systems.

Later, when we're focused more on things like packaging, we will ensure that all components get built for all operating systems. 

If the pre-built binaries don't work or are unavailable for your system, you will need to build the platform yourself.

### Building Nym

Nym has two main codebases:

* the Nym platform ([build instructions](build-nym)), written in Rust. This contains all of our code _except_ for the validators. 
* the Nym validators ([build instructions](validators)), written in Go.


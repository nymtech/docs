---
title: The Nym Platform
weight: 10
description: "An overview of the Nym platform architecture"
---

We are running a [testnet](https://dashboard.nymtech.net) with Nym validators and mixnodes. Together, the validators and mixnodes provide integrated transaction and network privacy to users of the Nym platform. They are assisted by several other platform components: multiple types of clients, and gateway nodes.

Here's an overview of the entire network. 

![Nym Platform](/docs/images/nym-platform.png)

The mixnodes provide network security for network content *and* metadata, making it impossible to see who is communicating with who. The validators secure the network with proof-of-stake Sybil defence, and also work together to create Coconut threshold credentials which provide anonymous access to data and resources. Gateway nodes act as message storage for clients which may go offline and come back online again.

The [Nym platform](https://github.com/nymtech/nym) developed by the Nym project includes mixnodes, validators, gateways, and client code used for talking to the network. All of this is run in a decentralised, trustless fashion. 

But the Nym platform itself (blue) is just infrastructure. The interesting part are the Privacy Enhanced Apps, or Peaps (yellow) which can be created by privacy developers. We've included some (fictional) examples of things we think people might build. Read our docs and use your imagination, and you may come up with many more!

Peaps are new or existing software applications which use the Nym platform infrastructure. 

Peaps can: 

* upgrade the privacy properties of existing applications, such as cryptographic wallets, VPNs, payment systems, chat, medical records, blockchains, exchanges, markets, DAOs or other allocation systems, etc
* enable completely new types of applications built from the ground up with privacy at their core

Peaps talk to the Nym network by connecting to gateway nodes. Peaps may go online and offline; the gateway provides a sort of mailbox where Peaps can receive their messages. 

There are two basic kinds of Peaps:

1. user facing apps running on mobile or desktop devices. These will typically expose a user interface (UI) to a human user. These might be existing apps such as crypto wallets that communicate with Nym via a (planned) SOCKS5 proxy, or entirely new apps.
2. Service Providers, which will usually run on a server, and take actions on behalf of users without knowing who they are.

Most Service Providers (SPs) will interact with external systems on behalf of a user. For example, an SP might submit a Bitcoin, Ethereum or Cosmos transaction, proxy a network request, talk to a chat server, or provide anonymized access to a medical system such as a [privacy-friendly coronavirus tracker](https://constructiveproof.com/posts/2020-04-24-coronavirus-tracking-app-privacy/). 

There is also a special category of Service Provider, namely SPs that do not visibly interact with any external systems. You might think of these as crypto-utopiapps: they're doing something, but it's not possible from outside to say with any certainty what their function is, or who is interacting with them.

All clients (and therefore all Peaps) talk with Nym gateway nodes using Sphinx packets and a defined set of messages called the Nym Gateway Protocol (NGP). NGP is a defined set of control messages that can be sent to Nym gateways over websockets. Each Peap has a long-lived relationship with its gateway; NGP defines messages for clients registering and authenticating with gateways, as well as sending encrypted Sphinx packets in specific formats.

We are currently focused on providing privacy for blockchain systems. But our ambitions are wider. In the medium term, we are actively working to bring together a range of new technologies that can enable strong privacy for the whole internet. There have not been many new widely-adopted privacy technologies to help internet users in the past 15 years. We are working hard to change that. 

## Current Status

The mixnet is now working, although there are many performance optimizations and reliability improvements still to be carried out. Mixnet APIs have mostly stabilised, and at this point it's possible to start building applications. 

Work on the validator code has started, but it's at a less advanced stage. The first release with some primitive staking capability is expected in June 2020. The rest of the validator code, including Coconut credential usage, should be ready to start testing in autumn 2020.

There is currently a mixnet client written in Rust, which runs in a standalone fashion on desktop or servers. You can use this for writing desktop or server Peaps in any language that speaks websocket (e.g. basically all of them). 

A Webassembly, or *wasm* client also exists as of the 0.7.x release. Wasm clients can be used within browser or mobile apps, and again communicate with gateways via websockets and NGP. The wasm client is not complete (it does not yet send cover traffic), but it is working to a point where you should be able to use it for application development. Cover traffic, when it is set up, will happen transparently and you shouldn't need to worry about it as a Peap developer.

Lastly, we are planning a SOCKS5 /  shadowsocks client so that it's easy to retrofit cryptocurrency wallets and other existing SOCKS-compatible applications to use Nym privacy infrastructure. This work has not yet started.

In the next few sections, we'll look at network privacy and resource access privacy in more detail. 
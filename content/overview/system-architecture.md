---
title: System Architecture
weight: 35
description: "Current project, community and development status of the Nym network."
---

We are running a [Nym testnet](https://dashboard.nymtech.net) with Nym validators and mixnodes. Together, the validators and mixnodes provide integrated transaction and network privacy to users of the Nym platform.

Here's an overview of the entire network. 

![Nym Platform](/docs/images/nym-platform.png)

The mixnet, composed of multiple mixnodes, provides a network security layer. The validator nodes secure the network with proof-of-stake Sybil defence, and also create Coconut threshold credentials. Gateway nodes act as mailboxes for clients which may go offline and come back online again.

The Nym platform includes mixnodes, validators, gateways, and client code used for talking to the network. All of this is run in a decentralised, trustless fashion. But the Nym platform (blue) is just infrastructure. The interesting part are the Privacy Enhanced Apps, or PEApps (yellow). 

PEApps are new or existing software applications which use the Nym platform infrastructure. 

PEApps can either: 

* upgrade the privacy properties of existing applications, such as cryptographic wallets, VPNs, payments, chat, medical records, blockchains, exchanges, markets, DAOs or other allocation systems, etc
* enable completely new types of applications built from the ground up with privacy at their core

PEApps talk to the Nym network by connecting to Nym gateway nodes. PEApps may go online and offline; the gateway provides a sort of mailbox where PEApps can receive their messages. 

There are two basic kinds of PEApps:

1. user facing apps running on mobile or desktop devices. These will typically expose a user interface (UI) to a human user. These might be existing apps such as crypto wallets that communicate with Nym via a (planned) SOCKS5 proxy, or entirely new apps.
2. Service Providers, which will usually run on a server, and may take actions on behalf of users without knowing who they are.

Most Service Providers (SPs) will interact with external systems on behalf of a user. For example, an SP might submit a Bitcoin, Ethereum or Cosmos transaction, proxy an HTTP request, talk to a chat server or provide anonymized access to a medical system such as a [privacy-friendly coronavirus tracker](https://constructiveproof.com/posts/2020-04-24-coronavirus-tracking-app-privacy/). 

There is also a special category of Service Provider, namely SPs that do not visibly interact with any external systems. You might think of these as crypto-utopiapps: they're doing something, but it's not possible from outside to say with any certainty what their function is, or who is interacting with them. 

All clients (and therefore all PEApps) talk with Nym gateway nodes using Sphinx packets and/or a defined set of messages called the Nym Gateway Protocol (NGP). NGP is a defined set of control messages that can be sent to Nym gateways over websockets. 

## Current Status

The mixnet is now working, although there are many performance optimizations and reliability improvements still to be carried out. Mixnet APIs have mostly stabilised, and at this point it's possible to start building applications. 

Work on the validator code has started, but it's at a less advanced stage. The first release with some primitive staking capability is expected in June 2020. The rest of the validator code, including Coconut credential usage, should be ready to start testing in autumn 2020.

There is currently a mixnet client written in Rust, which runs in a standalone fashion on desktop or servers. You can use this for writing desktop or server PEApps in any language that speaks websocket (e.g. basically all of them). 

A Webassembly, or *wasm* client also exists as of the 0.7.x release. Wasm clients can be used within browser or mobile apps, and again communicate with gateways via websockets. The wasm client is not complete (it does not yet send cover traffic), but it is working to a point where you should be able to use it for application development. Cover traffic, when it is set up, will happen transparently and you shouldn't need to worry about it as a PEApp developer. 

Lastly, we are planning a SOCKS5 /  shadowsocks client so that it's easy to retrofit cryptocurrency wallets and other existing SOSCKS-compatible applications to use Nym privacy infrastructure. This work has not yet started.
---
title: The Nym Platform
weight: 10
description: "An overview of the Nym platform architecture"
---

We are currently running a [testnet](https://explorer.nymtech.net) with Nym validators and mixnodes. Together, the validators and mixnodes provide integrated access control and network privacy to users of the Nym platform. They are assisted by several other platform components: multiple types of clients, and gateway nodes.

Here's an overview of the entire network. 

![Nym Platform](/docs/images/nym-platform.png)

The [Nym platform](https://github.com/nymtech/nym) includes mixnodes, validators, gateways, and client code used for talking to the network. All of this is run in a decentralized, trustless fashion. 

The mixnodes provide network security for network content *and* metadata, making it impossible to see who is communicating with who. 

Validators secure the network with proof-of-stake Sybil defences, determine which nodes are included within the network, and work together to create Coconut threshold credentials which provide anonymous access to data and resources. 

Gateway nodes act as message storage for clients which may go offline and come back online again, and defend against denial of service attacks.

But the Nym platform (blue) is just infrastructure. The interesting part are the privacy enhanced apps (yellow) which can be created by privacy developers or hooked into the network for existing applications. We've included some (fictional) examples of things we think people might build or integrate. Read our docs and use your imagination, and you may come up with many more!

Nym-enhanced applications can: 

* upgrade the privacy properties of existing applications, such as cryptographic wallets, VPNs, payment systems, chat, medical records, blockchains, exchanges, markets, DAOs or other allocation systems. 
* enable completely new types of applications built from the ground up with privacy at their core

Apps talk to the Nym network by connecting to gateway nodes. Applications may go online and offline; the gateway provides a sort of mailbox where apps can receive their messages. 

There are two basic kinds of privacy enhanced applications:

1. user facing apps running on mobile or desktop devices. These will typically expose a user interface (UI) to a human user. These might be existing apps such as crypto wallets that communicate with Nym via our SOCKS5 proxy, or entirely new apps.
2. Service Providers, which will usually run on a server, and take actions on behalf of users without knowing who they are.

Service Providers (SPs) may interact with external systems on behalf of a user. For example, an SP might submit a Bitcoin, Ethereum or Cosmos transaction, proxy a network request, talk to a chat server, or provide anonymous access to a medical system such as a [privacy-friendly coronavirus tracker](https://constructiveproof.com/posts/2020-04-24-coronavirus-tracking-app-privacy/). 

There is also a special category of Service Provider, namely SPs that do not visibly interact with any external systems. You might think of these as crypto-utopiapps: they're doing something, but it's not possible from outside to say with any certainty what their function is, or who is interacting with them.

All apps talk with Nym gateway nodes using Sphinx packets and a small set of simple control messages. These messages are sent to gateways over websockets. Each app client has a long-lived relationship with its gateway; Nym defines messages for clients registering and authenticating with gateways, as well as sending encrypted Sphinx packets.

We are currently focused on providing privacy for blockchain systems. But our ambitions are wider. In the medium term, we are actively working to bring together a range of new technologies that can enable strong privacy for the whole internet. There have not been many new widely-adopted privacy technologies to help internet users in the past 15 years. We are working hard to change that. 

## Current Status

The mixnet and validators are now working. 

Mixnet APIs have mostly stabilized, and at this point it's possible to start building applications. 

Validators are now working in their most basic form, and include a reputation token called `nym`. Later, validators will also generate Coconut credentials.

There is currently a native mixnet client written in Rust. It runs in standalone fashion on desktops or servers. You can use this for connecting desktop or server apps to the Nym network, using any language that speaks websockets.

A webassembly client also exists. Webassembly clients can be used within browser or mobile apps, and again communicate with gateways via websockets. The webassembly client is not complete (it does not yet send cover traffic), but it is working to a point where you should be able to use it for application development. Cover traffic, when it is set up, will happen transparently and you shouldn't need to worry about it as a Nym app developer.

Lastly, a SOCKS5 client and Service Provider (called SphinxSocks) makes it easy to retrofit cryptocurrency wallets and other existing SOCKS-compatible applications to use Nym privacy infrastructure. 

In the next few sections, we'll look at network privacy and access privacy in more detail. 
---
weight: 10
title: Introduction
---

# Introduction

Nym is a blockchain-based privacy platform. It combines network level privacy against sophisticated end-to-end attackers, and an anonymizing layer for transactions using decentralised blinded credentials. Our goal is to allow developers to enable their applications with advanced privacy features unavailable in other systems.

At present, our architecture has two main components: **Coconut** and **Loopix**.

## Coconut

Coconut provides blinded credentials based on the testimony of a set of decentralized, blockchain-based issuing authorities. It implements the threshold credentials protocol detailed in the [Coconut](https://arxiv.org/abs/1802.07344) academic paper. It allows users to receive cryptographic claims from a set of authorities, then cut the link between the issued credentials while still allowing third-party systems to verify the claims.

As an example of its uses, consider VPN systems.

Today, VPN providers typically hold payment data allowing them to de-anonymize their users - not because they want to, but because it isn't possible to answer the question "has this person paid to use our service?" without seeing a credit card payment.

Coconut can solve this problem: a set of decentralised authorities verify payment and give the user a cryptographic credential. The credential contains an assertion that the user has paid, without any other identifying data. The user's Coconut client then re-randomizes the credential, so that it's a completely different credential than what the issuing authority provided (thus providing anonymity).

When the user attempts to use the VPN service, the VPN provider can check this the anonymous credential with the issuing authority to prove that payment happened. However, neither the Issuing Authority nor the VPN service know nothing else about the user.

The VPN example is a simple way of explaining Coconut via a single use case. However, it's worth noting that Coconut is a general-purpose system. Many other applications are possible (electronic voting systems, interaction with business or government systems giving up minimal data, or storing data in publicly-accessible blockchains without revealing whose data it is).

Coconut functionality is built in to the Nym core platform. Nym uses a [Tendermint](https://tendermint.com/) blockchain to keep track of credential issuance and prevent double-spending of credentials. It also contains server-side APIs to support querying of credentials. There is client-side code to re-randomize credentials.

## Loopix

Loopix is a mixnet, implementing the network anonymity protocol detailed in the [Loopix](https://arxiv.org/abs/1703.00536) and [Sphinx](http://www0.cs.ucl.ac.uk/staff/G.Danezis/papers/sphinx-eprint.pdf) academic papers. It fulfils a similar function to the onion routing in [Tor](https://www.torproject.org/), in that it provides anonymity against attackers who may be monitoring your network traffic or metadata. However, it offers improved protection against adversaries who can monitor the network in its entirety.

Assume a God-like adversary who can watch every packet on the network, record everything, and analyze everything in real-time. Is it possible to have private communications in such an environment? Intuitively, the answer is no: the attacker can watch every request and response, requests and responses, and progressively identify users with a high probability of success.

Loopix solves this problem by *mixing* messages inside network nodes, and adding small random delays to packet transmission. Assume 10,000 messages enter a node during an interval. Each message is then emitted out of order with a small random delay, and sent to another mix node that also has 10,000 messages in it, then to a third mixnode with a further 10,000 messages, and then finally delivered to its destination. Even a God-like attacker will not be able to trace the flow of traffic through the system.

Loopix mitigates against packet-dropping attacks by malicious nodes, and ensures quality-of-service, via *loop* and *cover* traffic, where clients and nodes send messages to themselves to ensure that messages are being delivered properly and that enough messages are going through the system to provide privacy for everyone.

Applications that need to defend against network-level monitoring can use Loopix - private messaging, VPNs, and other applications to enable strong privacy.

A project wanting only private credentials, but no network defences, should be able use Coconut by itself. Conversely, an application that only needs to defend against network attackers can use Loopix by itself, without Coconut. But developers that need end-to-end protection at both the network and transaction level can use both together.

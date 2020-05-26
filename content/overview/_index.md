---
title: Overview
weight: 2
description: "Nym is a blockchain-based privacy platform. It provides strong network-level privacy against sophisticated end-to-end attackers, and anonymous transactions using blinded, re-randomizable, decentralized credentials."
---

Nym has several core technologies, integrated into different types of networked nodes.

1. a privacy enhancing signature scheme called **Coconut**, used in the Nym validator nodes. Validators also secure the network through proof of stake sybil defences.
2. **Sphinx**, a way of transmitting armoured, layer-encrypted information packets which are indistinguishable from each other at a binary level.
3. a **mixnet**, which encrypts and *mixes* Sphinx packet traffic so that it cannot be determined who is communicating with whom. Our mixnet is based on a modified version of the **Loopix** mixnet design.

These technologies ensure privacy at two different levels of the stack: network data transmission, and transactions.

Most systems concentrate on only one of these layers at a time.

For example, zero knowledge proof systems deal only with on-chain transaction privacy. Conversely, Tor deals only with network privacy. 

Nym is the first system we're aware of which provides integrated protection on both layers at once. We think that this seamless approach gives the best possible privacy protections, ensuring that nothing falls through the cracks between systems.



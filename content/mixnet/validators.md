---
title: "Validators"
weight: 30
description: "Nym Validators provide privacy-enhanced credentials based on the testimony of a set of decentralized, blockchain-based issuing authorities."
---

Nym validators secure the network with a staking token, defending the network from Sybil attacks. Validators communicate with each either by running the [Tendermint](https://tendermint.com) BFT consensus protocol.

Validators also provide privacy-enhanced credentials based on the testimony of a set of decentralized, blockchain-based issuing authorities. Nym validators use a [signature scheme](https://en.wikipedia.org/wiki/Digital_signature) called [Coconut](https://arxiv.org/abs/1802.07344) to issue credentials. This allows PEApps to generate anonymous resource claims through decentralised authorities, then use them with Service Providers.

Nym validators are still under construction. Simple build instructions are noted in the [Quickstart](/docs/quickstart/). 

Expect the beginnings of a useful validator in the upcoming 0.8.0 release of the Nym platform.
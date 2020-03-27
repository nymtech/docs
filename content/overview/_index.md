---
title: Overview
weight: 2
pre: "<b>1. </b>"
description: "Nym is a blockchain-based privacy platform. It provides strong network-level privacy against sophisticated end-to-end attackers, and anonymous transactions using blinded, re-randomizable, decentralized credentials."
---

Nym is a blockchain-based privacy platform. It provides strong network-level privacy against sophisticated end-to-end attackers, and anonymous transactions using blinded, re-randomizable, decentralized credentials.

Our goal is to allow developers to enable their applications with advanced privacy features unavailable in other systems.

Nym has a few core technologies, integrated into different types of networked nodes.

1. a privacy enhancing signature scheme called *Coconut*, used in the [Nym Validator](https://github.com/nymtech/nym-validator) nodes.
1. a *mixnet*, which encrypts and *mixes* network traffic through [Nym Mixnodes](https://github.com/nymtech/nym-mixnode) so that it cannot be determined who is communicating with whom. Our mixnet is based on the *Sphinx* cryptographic packet format and a modified version of the *Loopix* mixnet design.

The two technologies ensure privacy at different levels of the stack.

### Transaction privacy

In the context of blockchain systems, **Coconut** provides **transaction privacy**. Typically this happens by transferring a coin to an address, then creating a privacy-enhanced Coconut credential which provably represents the input amount. The credential can then be "spent" anonymously, as if it were the original value. Double-spending protections apply to the credential, so it can only be spent once. Nym Validators can then unlock the value so it can be redeemed by the party holding the anonymized credential.

Although there's still work to be done to integrate it against various blockchains, in principle Coconut can anonymize blockchain transactions in any system which provides multi-sig. Bitcoin and Ethereum are obvious first targets here.

Coconut is very flexible, and can ensure privacy for more than coin transfers; it can ensure privacy for more complex smart contracts as well. Finally, it should be mentioned that Coconut can be applied to both blockchain and non-blockchain systems - it's a general purpose technology.

### IP-layer privacy

The **Nym Mixnet** provides privacy at the **IP network level**.

When you send any data across the internet, it can be tracked by a wide range of observers: your ISP, internet infrastructure providers, large tech companies, and governments.

Even if the *content* of the transaction is encrypted, observers can still see that data was transmitted, and gather metadata from unencrypted parts of the data (such as IP routing information). For a public blockchain transaction, it may then be possible to infer message content based on what then becomes visible in e.g. the chain.

Even though your transaction on-chain may be private (in the case of a privacy-focused blockchain such as ZCash), you may still have problems if your transaction information was captured in transit and its metadata and timing information analyzed.

The Nym Mixnet provides very strong security guarantees against this sort of surveillance. It *packetizes* and *mixes* together IP traffic from many users inside a *mixnet*: a decentralized system composed of many *mixnodes*.

A mixnet can be used to secure blockchain or non-blockchain systems. Things like crypto-currency wallets are a natural fit for mixnets; but so are non-blockchain things like chat systems.

If you're into comparisons, the Nym Mixnet is conceptually similar to other systems such as Tor, but provides improved protections against timing attacks. The Nym mixnet re-orders encrypted, indistinguishable [Sphinx](https://cypherpunks.ca/~iang/pubs/Sphinx_Oakland09.pdf) packets as they travel through the mixnodes. Our mixnet design based on the [Loopix Anonymity System](https://arxiv.org/abs/1703.00536), although slightly modified.

### Coconut Credentials vs Mixnets

An application requiring only private credential signing, but no network-level defences, can use Coconut credentials via the Nym Validators.

Conversely, an application that only needs to defend against IP traffic analysis can use the Nym Mixnet by itself, without the Nym Validators.

But developers that need end-to-end protection at both the IP network and transaction level can use Coconut and the mixnet together.

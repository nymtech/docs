---
# Page settings
layout: default
keywords:
comments: false

# Hero section
title: Overview

# Micro navigation
micro_nav: true

# Page navigation
page_nav:
    next:
        content: Nym Validators
        url: 'validators'
---

Nym is a blockchain-based privacy platform. It combines network level privacy against sophisticated end-to-end attackers, and an anonymizing layer for transactions using blinded, re-randomizable, decentralized credentials. Our goal is to allow developers to enable their applications with advanced privacy features unavailable in other systems.

At present, our running Nym testnet architecture has two main components: **Validator nodes**, and **Mixnodes**.

There's also a **Nym Directory**, and a **Dashboard** providing an overview of current network status. Everything shown in the diagram is currently running on the internet, and you're welcome to try our systems out.

![overview](assets/nym-testnet.png)

## Core technologies

Nym currently consists of two core technologies:

1. a privacy enhancing signature scheme called *Coconut*, used in the [Nym Validator](https://github.com/nymtech/nym-validator) nodes.
1. a *mixnet*, which encrypts and *mixes* network traffic through [Nym Mixnodes](https://github.com/nymtech/nym-mixnode) so that it cannot be determined who is communicating with whom. Our mixnet is based on the *Sphinx* cryptographic packet format and a modified version of the *Loopix* mixnet design.

The two technologies ensure privacy at different levels of the stack.

In the context of blockchain systems, **Coconut** provides **transaction privacy**. Typically this happens by transferring a coin to an address, then creating a privacy-enhanced Coconut credential which provably represents the input amount. The credential can then be "spent" anonymously, as if it were the original value. Double-spending protections apply to the credential, so it can only be spent once. Nym Validators can then unlock the value so it can be redeemed by the party holding the anonymized credential.

Although there's still work to be done to integrate it against various blockchains, in principle Coconut can anonymize blockchain transactions in any system which provides multi-sig.

Coconut is very flexible, and can ensure privacy for more than coin transfers; it can ensure privacy for more complex smart contracts as well.

Finally, it should be mentioned that Coconut can be applied to non-blockchain systems as well - it's a general purpose technology.

The **Nym Mixnet**, in contrast, ensures privacy at the **network level**. When you initiate an on-chain transaction, the transaction data you're sending can be tracked as the IP layer information travels across the internet. Even if the content of the transaction is encrypted, observers can still see the IP layer information and infer its content based on what then becomes visible in e.g. a public blockchain. So even though your transaction on-chain may be private, you have already lost the game if your information was captured in transit and subjected to timing attacks.

The Nym Mixnet provides very strong security guarantees against this sort of surveillance, by mixing together IP traffic from many users inside a decentralized system of mixnodes.

The mixnet can be used to secure both blockchain and non-blockchain systems. Things like crypto-currency wallets are a natural fit for mixnets; but so are non-blockchain things like chat systems.

The Nym Mixnet is conceptually similar to other systems such as Tor, but provides improved protections against timing attacks because it re-orders encrypted, indistinguishable Sphinx packets as they travel through the nodes.

## Coconut Credentials vs Mixnodes

An application wanting only private credential signing, but no network-level defences, can use Coconut credentials via the Nym Validators.

Conversely, an application that only needs to defend against network attackers can use the Nym Mixnet by itself, without the Nym Validators.

But developers that need end-to-end protection at both the network and transaction level can use both together.

At present the two parts of the system have not yet been connected together (so there is not yet the possibility to protect network traffic when generating credentials). We're working on it!

---
title: Overview
weight: 2
description: "Nym is a blockchain-based privacy platform. It provides strong network-level privacy against sophisticated end-to-end attackers, and anonymous access control using blinded, re-randomizable, decentralized credentials."
---

The internet has become essential to the functioning of modern society. Many aspects of daily life are now touched by the internet in ways that are both mundane and deeply revolutionary. Everything is accelerating.

But the internet we have is not the internet we wished we'd have. The increase in surveillance over the past twenty years has not been matched by advances in privacy tech. Nym is an attempt to redress this imbalance.

The Nym platform knits together several privacy technologies, integrating them into a system of cooperating networked nodes.

At a high level, our technologies include:

1. a privacy enhancing signature scheme called *Coconut*. Coconut allows a shift in thinking about resource access control, from an identity-based paradigm based on *who you are* to a privacy-preserving paradigm based on *right to use*. 
2. *Sphinx*, a way of transmitting armoured, layer-encrypted information packets which are indistinguishable from each other at a binary level.
3. a *mixnet*, which encrypts and mixes Sphinx packet traffic so that it cannot be determined who is communicating with whom. Our mixnet is based on a modified version of the *Loopix* design.

We'll explore Coconut, Sphinx, and Loopix in detail in the next few sections. The most important thing to note is that these technologies ensure privacy at two different levels of the stack: network data transmission, and transactions.

## How does Nym compare to other systems?

Nym is the first system we're aware of which provides integrated protection on both the network and transaction level at once. We think that this seamless approach gives the best possible privacy protections, ensuring that nothing falls through the cracks between systems.

Most comparable systems concentrate on only one of these layers at a time.

For example, some blockchain-based systems contain zero knowledge proof systems that deal only with on-chain transaction privacy. This leaves network privacy as an exercise for the user. It's easy to get it wrong.

Conversely, Tor deals only with network privacy, and has nothing built-in to help with transaction privacy. If you include identifiable information in your Tor network requests (which can happen accidentally), the privacy protections are void.

Speaking of Tor, our claim is that mixnets like Nym give stronger security guarantees against end-to-end network tracing attacks that are becoming easier to operationalize, and which we'll see more of in future. 

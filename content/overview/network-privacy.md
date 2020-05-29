---
title: Network Privacy
weight: 30
description: "Nym ensures network privacy using layer encrypted Sphinx packets and a Loopix mixnet."
---

When you send data across the internet, it can be tracked by a wide range of observers: your ISP, internet infrastructure providers, large tech companies, and governments.

Even if the *content* of a network request is encrypted, observers can still see that data was transmitted, its size, frequency of transmission, and gather metadata from unencrypted parts of the data (such as IP routing information). Adversaries then use all the leaked information to probabilistically de-anonymize users.

Claudia's lightning talk from Dappcon 2019 in Berlin gives a general overview of network privacy.

{{< youtube 5A378jgYXSc >}}

The Nym mixnet provides very strong security guarantees against this sort of surveillance. It *packetizes* and *mixes* together IP traffic from many users inside a *mixnet*: a decentralized system composed of many *mixnodes*.

A mixnet can be used to secure blockchain or non-blockchain systems. Things like crypto-currency wallets are a natural fit for mixnets; but so are non-blockchain things like chat systems, or systems for which you want wide usage but strong privacy guarantees for users, such as coronavirus tracking apps.

If you're into comparisons, the Nym mixnet is conceptually similar to other systems such as Tor, but provides improved protections against end-to-end timing attacks which can de-anonymize users. When Tor was first fielded, in 2002, those kinds of attacks were regarded as science fiction. But the future is now here. 

## Loopix, the Nym mixnet

To meet these new threats, the Nym mixnet re-orders encrypted, indistinguishable [Sphinx](https://cypherpunks.ca/~iang/pubs/Sphinx_Oakland09.pdf) packets as they travel through the mixnodes. Our mixnet design based on the [Loopix Anonymity System](https://arxiv.org/abs/1703.00536), somewhat modified to provide better quality of service guarantees. Another of our researchers, Ania, is an author of the Loopix academic paper.

This short video features Ania discussing the Loopix mixnet design in detail at USENix 2017.

{{< youtube R-yEqLX_UvI >}}

There is a very non-technical introduction to mixnets in the blog post [A Simple Introduction to Mixnets](https://medium.com/nymtech/a-simple-introduction-to-mixnets-6783a103d20e). But here's the boiled-down explanation.

Assume a God-like adversary who can watch every packet on the network, record everything, and analyze everything in real-time. Is it possible to have private communications in such an environment? Intuitively, the answer is no: the adversary can watch every packet as it travels through the network, and progressively identify users with a high degree of success using probabilistic techniques.

The Nym mixnet solves this problem by *mixing* messages inside network nodes which are opaque to the adversary. Each packet is encrypted, and binary-padded so that it's indistinguishable from all other packets. Incoming packets are "mixed" with all other messages inside the node. That is, the node strips a layer of packet encryption, and adds a small random transmission delays, so that messages are not emitted in the same order as which they arrived.

Next, the message is sent to another mix node and mixed again, then to a third mixnode for further mixing. Finally, the message is delivered to its destination.

As long as there's enough traffic flowing through the nodes, even an adversary who can record the whole internet will not be able to trace the packet flow through the system.

The Nym mixnet mitigates against packet-dropping attacks by malicious nodes, and ensures quality-of-service, via *loop* traffic. Clients send messages which *loop* back to themselves. This allows clients to assure themselves that messages are being delivered properly. It also provides *cover traffic* to ensure that enough messages are going through the system to provide privacy.

Applications that need to defend against network-level monitoring can use the Nym mixnet - private messaging, VPNs, and other applications to enable strong privacy.

The end result is that adversaries are unable to monitor Privacy Enhanced Applications (PEApps) using Nym even if they can record all internet traffic. The adversary can tell that a user's PEApp has connected to the mixnet; beyond that, it's impossible to say whether they are doing encrypted chat, file transfer, or interacting with another PEApp.


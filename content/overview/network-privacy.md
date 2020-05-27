---
title: Network Privacy
weight: 30
description: "Nym ensures network privacy using layer encrypted Sphinx packets and a Loopix mixnet."
---

When you send data across the internet, it can be tracked by a wide range of observers: your ISP, internet infrastructure providers, large tech companies, and governments.

Even if the *content* of a network request is encrypted, observers can still see that data was transmitted, its size, frequency of transmission, and gather metadata from unencrypted parts of the data (such as IP routing information). 

In the case of a blockchain transaction, it may be possible to infer message content based on what then becomes visible in the blockchain, which is public. Even though your transaction on-chain may be private (in the case of a privacy-focused blockchain such as ZCash), you may still have problems if your transaction information was captured in transit and its metadata and timing information analysed.

The Nym mixnet provides very strong security guarantees against this sort of surveillance. It *packetizes* and *mixes* together IP traffic from many users inside a *mixnet*: a decentralized system composed of many *mixnodes*.

A mixnet can be used to secure blockchain or non-blockchain systems. Things like crypto-currency wallets are a natural fit for mixnets; but so are non-blockchain things like chat systems.

If you're into comparisons, the Nym mixnet is conceptually similar to other systems such as Tor, but provides improved protections against timing attacks. The Nym mixnet re-orders encrypted, indistinguishable [Sphinx](https://cypherpunks.ca/~iang/pubs/Sphinx_Oakland09.pdf) packets as they travel through the mixnodes. Our mixnet design based on the [Loopix Anonymity System](https://arxiv.org/abs/1703.00536), somewhat modified to provide better quality of service guarantees.

There is a non-technical introduction to mixnets in the blog post [A Simple Introduction to Mixnets](https://medium.com/nymtech/a-simple-introduction-to-mixnets-6783a103d20e) by our CTO.

Claudia's lightning talk from Dappcon 2019 in Berlin gives a speedy and more intellectual overview of network privacy:

{{< youtube 5A378jgYXSc >}}

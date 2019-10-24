---
title: "Mixnet"
weight: 20
pre: "<b>2. </b>"
---

### Mixnets for network privacy

Nym has a mix network, or mixnet, which is composed of mix nodes.

The [Nym Mixnet](https://github.com/nymtech/nym-mixnet) implements a modified version of the network anonymity protocols detailed in the [Loopix](https://arxiv.org/abs/1703.00536) and [Sphinx](http://www0.cs.ucl.ac.uk/staff/G.Danezis/papers/sphinx-eprint.pdf) academic papers. It fulfils a similar function to the onion routing in [Tor](https://www.torproject.org/), in that it provides anonymity against attackers who may be monitoring your network traffic or metadata. However, it offers improved protection against adversaries who can monitor the network in its entirety.

Assume a God-like adversary who can watch every packet on the network, record everything, and analyze everything in real-time. Is it possible to have private communications in such an environment? Intuitively, the answer is no: the attacker can watch every request and response, and progressively identify users with a high degree of success using probabilistic techniques.

The Nym Mixnet solves this problem by *mixing* messages inside network nodes which are opaque to the attacker. Each packet is encrypted, and binary-padded so that it's indistinguishable from all other packets. Incoming packets are "mixed" with all other messages inside the node. That is, the node strips a layer of packet encryption, and adds a small random transmission delays, so that messages are not emitted in the same order as which they arrived.

Next, the message is sent to another mix node and mixed again, then to a third mixnode for further mixing. Finally, the message is delivered to its destination.

As long as there's enough traffic flowing through the nodes, even an attacker who can record the whole internet will not be able to trace the packet flow through the system.

The Nym Mixnet mitigates against packet-dropping attacks by malicious nodes, and ensures quality-of-service, via *loop* traffic. Clients send messages which *loop* back to themselves. This allows clients to assure themselves that messages are being delivered properly. It also provides *cover traffic* to ensure that enough messages are going through the system to provide privacy.

Applications that need to defend against network-level monitoring can use the Nym Mixnet - private messaging, VPNs, and other applications to enable strong privacy.

### Our current Mixnet architecture

![mixnet](/docs/images/mixnet.png)

The next few sections will discuss each piece of the puzzle. First, you'll need to build the code so you can try things out.

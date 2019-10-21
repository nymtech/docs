---
# Page settings
layout: default
keywords:
comments: false

# Hero section
title: Mixnodes
description: Network-level privacy

# Micro navigation
micro_nav: true

# Page navigation
page_nav:
    prev:
      content: Validators
      url: '../validators'
    next:
      content: Directory, Dashboard & Other Components
      url: '../directory-dashboard-components'
---



## Mixnodes for network privacy

Nym also has a mix network, or mixnet, which is composed of mix nodes.

The Nym mixnet implements a modified version of the network anonymity protocol detailed in the [Loopix](https://arxiv.org/abs/1703.00536) and [Sphinx](http://www0.cs.ucl.ac.uk/staff/G.Danezis/papers/sphinx-eprint.pdf) academic papers. It fulfils a similar function to the onion routing in [Tor](https://www.torproject.org/), in that it provides anonymity against attackers who may be monitoring your network traffic or metadata. However, it offers improved protection against adversaries who can monitor the network in its entirety.

Assume a God-like adversary who can watch every packet on the network, record everything, and analyze everything in real-time. Is it possible to have private communications in such an environment? Intuitively, the answer is no: the attacker can watch every request and response, and progressively identify users with a high probability of success using probabilistic techniques.

The Nym Mixnet solves this problem by *mixing* messages inside network nodes which are opaque to the attacker. Each message is then "mixed" with all other messages inside the node. That is, the node strips a layer of packet encryption, and adds a small random delays to packet transmission, so that messages are emitted out of order.

Next, the message is sent to another mix node and mixed again, then to a third mixnode for further mixing. Finally, the message is delivered to its destination.

Even an attacker who can record the whole internet will not be able to trace the flow of traffic through the system.

The Nym Mixnet mitigates against packet-dropping attacks by malicious nodes, and ensures quality-of-service, via *loop* traffic, where clients send messages to themselves to ensure that messages are being delivered properly and that enough messages are going through the system to provide privacy for everyone.

Applications that need to defend against network-level monitoring can use the Nym Mixnet - private messaging, VPNs, and other applications to enable strong privacy.

## Our current Mixnet architecture

![mixnet](../assets/mixnet.png)

---
# Page settings
layout: default
keywords:
comments: false

# Hero section
title: Directory, Dashboard & Other Components
description: Supporting components to make the system functional, reliable and incentivized

# Micro navigation
micro_nav: true

# Page navigation
page_nav:
    prev:
      content: Validators
      url: '../validators'
    next:
      content: TODO
      url: '#'
---

## Directory

Note that in both the Nym Validators and Nym Mixnet discussions above, quite a bit is assumed. How does the client know which nodes exist, and what their IP addresses are? How does it find out their public keys so it can encrypt messages to them, and verify that responses came from them? How can we measure the overall throughput?

The [Nym Directory](https://github.com/nymtech/nym-directory) handles all of these concerns:

* presence - each Nym node sends a heartbeat message to the Directory every few seconds so we know what's running
* public key infrastructure (PKI) - each node sends its public key as an identifier with the presence messages
* metrics - if desired, Nym Mixnodes can optionally send information about packets sent/received to the Nym Directory, so we can monitor performance in the testnet. If you would like to implement any Nym Mixnet visualizations, there's a websocket available for metrics at [wss://directory.nymtech.net/ws](wss://directory.nymtech.net/ws)

The Nym Directory is accessible by a simple REST API. Swagger docs are at [https://directory.nymtech.net/swagger/index.html](https://directory.nymtech.net/swagger/index.html)

As you'll note from the architecture diagram, the Nym Directory is currently centralised. This is not desirable as it's a single point of failure (or attack) for the system as a whole.

While we're still in early testnet mode, the Nym Directory works well enough to bootstrap the testnet into existence.

Once our mixnet Quality of Service system, and Proof of Stake system, is running, we will eventually move the functionality of the Directory into the Nym Validator nodes.

## Dashboard

You can see a simple representation of the overall Nym network at [https://dashboard.nymtech.net/](https://dashboard.nymtech.net/). This also shows you a live reading of traffic metrics being sent over the mixnet. The **sent** and **received** numbers on each mixnode shows how many packets it has received and sent in the past 1 second.

## Other components

Other components, not yet built, will be necessary in the full system.

### Proof of Stake

Nym nodes will rely on a Proof of Stake (PoS) mechanism for both sybil defenses and mixnode quality of service monitoring. This not yet written, primarily because measuring quality of service in order to achieve mixnode stake slashing in a trustless environment was an unsolved problem until very recently (see below).

### Quality of Service Monitoring

The Nym Mixnodes currently incorporate a simple, but individualistic, mechanism for determining quality of service. Connected clients periodically send "loop" messages to themselves. This provides network cover traffic and also allows each client to check that its messages are getting through.

This works reasonably well for a single client, but it breaks down when we want to check quality of service across the system as a whole, in a trustless environment. A client reporting that its messages never made it past Mixnode A could in fact be an attacker who wants to knock the honest, reliable, and perfectly functional Mixnode A out of the network.

We have come up with a solution to this problem, allowing auditing of mixnode behaviour across the system as a whole. Once that's working, we will have the ability to stake slash in cases where a Nym Mixnode fails to provide good service.

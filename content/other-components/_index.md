---
title: "Other Components"
weight: 50
pre: "<b>5. </b>"
description: "You can see a simple representation of the overall Nym network at the Nym Dashboard. This also shows you a live reading of traffic metrics being sent over the mixnet. The **sent** and **received** numbers on each mixnode shows how many packets it has received and sent in the past 1 second."
---

### Nym Dashboard

You can see a simple representation of the overall Nym network at [https://dashboard.nymtech.net/](https://dashboard.nymtech.net/). This also shows you a live reading of traffic metrics being sent over the mixnet. The **sent** and **received** numbers on each mixnode shows how many packets it has received and sent in the past 1 second.

### Other components

Other components, not yet built, are currently being designed. The Nym Whitepaper (forthcoming) details the overall system design and how these parts will fit in. But here's a preview.

#### Proof of Stake

Nym nodes will rely on a Proof of Stake (PoS) mechanism for both sybil defenses and mixnode quality of service monitoring. This not yet written, primarily because measuring mixnode quality of service for stake slashing was an unsolved problem until very recently.

#### Mixmining: Quality of Service Monitoring for mixnets

The Nym Mixnodes currently incorporate a simple, but individualistic, mechanism for determining quality of service. Connected clients periodically send "loop" messages to themselves. This provides network cover traffic and also allows each client to check that its messages are getting through.

This works reasonably well for a single client, but it breaks down when we want to check quality of service across the system as a whole, in a trustless environment. A client reporting that its messages never made it past Mixnode A could in fact be an attacker who wants to knock the honest, reliable, and perfectly functional Mixnode A out of the network.

We have come up with a solution to this problem, allowing auditing of mixnode behaviour across the system as a whole. Once that's working, we will have the ability to stake slash in cases where a Nym Mixnode fails to provide good service.

#### Gateway

The gateway (forthcoming in Nym 0.7.x) will sit in front of the mixnet, and do the following:

* the gateway will always speak IPv4, (unlike mixnodes which may speak either IPv4 or IPv6). Having the gateway solves any issues where clients may not be able to speak to mixnodes due to protocol version issues, which can happen right now.
* offer a point where clients can speak WebSocket. This will allow JavaScripters (or other wasm users, like mobile app developers) to start a WebSocket, connect to the gateway, and start sending Sphinx packets. This is working now.
* check auth tokens for mixnet usage / billing purposes. The gateway will (eventually) do that job. 
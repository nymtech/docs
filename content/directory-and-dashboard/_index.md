---
title: "Other Components"
weight: 40
pre: "<b>4. </b>"
---

### Nym Dashboard

You can see a simple representation of the overall Nym network at [https://dashboard.nymtech.net/](https://dashboard.nymtech.net/). This also shows you a live reading of traffic metrics being sent over the mixnet. The **sent** and **received** numbers on each mixnode shows how many packets it has received and sent in the past 1 second.

### Nym Directory

Note that in the preceding discussions of Nym Validators and Nym Mixnodes, quite a bit is assumed. How does a mixnet client know which nodes exist, and what their IP addresses are? How does it find out their public keys so it can encrypt messages to them, and verify that responses came from them? How can the dashboard measure overall mixnet throughput?

The [Nym Directory](https://github.com/nymtech/nym-directory) handles all of these concerns:

* presence - each Nym node sends a heartbeat message to the Directory every few seconds so clients know what's running
* public key infrastructure (PKI) - each node sends its public key as an identifier with the presence messages
* metrics - if desired, Nym Mixnodes can optionally send information about packets sent/received to the Nym Directory, so we can monitor performance in the testnet. If you would like to implement any Nym Mixnet visualizations, there's a websocket available for metrics at `wss://directory.nymtech.net/ws`. If you would like to see its output in a browser, go to https://directory.nymtech.net/.

The Nym Directory exposes a simple REST API. Swagger docs are at [https://directory.nymtech.net/swagger/index.html](https://directory.nymtech.net/swagger/index.html)

The Nym Directory is currently centralised. This is not desirable as it's a single point of failure (or attack) for the system as a whole.

While we're still in early testnet mode, the Nym Directory works well enough to bootstrap the testnet into existence.

Once our mixnet Quality of Service system, and Proof of Stake system, they'll take over the functionality of the Directory.

### Other components

Other components, not yet built, are currently being designed.

#### Proof of Stake

Nym nodes will rely on a Proof of Stake (PoS) mechanism for both sybil defenses and mixnode quality of service monitoring. This not yet written, primarily because measuring mixnode quality of service for stake slashing was an unsolved problem until very recently.

#### Mixmining: Quality of Service Monitoring for mixnets

The Nym Mixnodes currently incorporate a simple, but individualistic, mechanism for determining quality of service. Connected clients periodically send "loop" messages to themselves. This provides network cover traffic and also allows each client to check that its messages are getting through.

This works reasonably well for a single client, but it breaks down when we want to check quality of service across the system as a whole, in a trustless environment. A client reporting that its messages never made it past Mixnode A could in fact be an attacker who wants to knock the honest, reliable, and perfectly functional Mixnode A out of the network.

We have come up with a solution to this problem, allowing auditing of mixnode behaviour across the system as a whole. Once that's working, we will have the ability to stake slash in cases where a Nym Mixnode fails to provide good service.

---
title: "Incentives"
weight: 15
description: "Why should you run Nym nodes?"
---

We will get into building the Nym codebase and running nodes in the next section. Before we do so, a note on token incentives.

We are starting to test out the incentives structure for running Nym nodes. At present, incentives apply only to mixnodes and may not reflect how the incentives structure will be on mainnet. Over the next few releases, it will extend to validators and gateways as well.

### Why incentives?

The Nym network has some of the same overall goals as [Tor](https://tor-project.org). But we want to enable Nym to scale in response to increased demand (and shrink when demand drops, so as not to waste resources). To do this in a decentralized way, nodes will be included in the network once they have a certain amount of reputation. Reputation is gained over time by running a node and providing reliable service.

### How to participate

Over the past few weeks, we have been doing incentives signup manually, using web forms. Rewards have been given out using a trial reputation token called `NYMPH`, which exists on both the Ethereum and Liquid blockchains. 

In this release (v0.9.x), we have gotten rid of the web signup forms. You can register your node for NYMPH tokens during the `init` or `upgrade` process. Rewards will still be given out manually, but the Nym network will now be automatically monitoring your nodes for uptime and mixing capability using a new component, the `nym-network-monitor`. This checks your node once a minute to ensure it is up and properly mixing packets. Your node reputation score (and therefore NYMPH rewards) are based on the results given by the network monitor. This is shown on the Nym testnet explorer at https://testnet-explorer.nymtech.net.

We are still in testnet and using NYMPH token for rewards. For coding ease, this token is called "NYM" on the Cosmos testnet chain. In upcoming releases, we will eventually launch a mainnet token NYM.


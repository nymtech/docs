---
title: "Joining our testnet"
weight: 60
description: "Joining the testnet, recommended hardware specifications, and networking setup for Nym."
---

Joining the Nym testnet with a mixnode is easy.

Once you've downloaded or compiled your mixnode according to the [installation](../installation) instructions, set it up on an internet-addressable server machine. It will automatically join our testnet. 

### Hardware Specs

* Processor: 2 or 4 cores are fine. Get the fastest CPUs you can afford. 
* RAM: Memory requirements are very low - typically a mixnode may use only a few hundred MB of RAM. 
* Disks: The mixnodes require no disk space beyond a few bytes for the configuration files

For the moment, we haven't put a great amount of thought into optimizing concurrency to increase throughput. So don't bother provisioning a beastly server with many cores. This will change when we get a chance to start doing performance optimizations in a more serious way. Later, once we've optimized, you will want the most cores you can get. 

### Network Setup

* IPv4 works
* IPv6 also works
* ensure that your node is available and announces the right address, especially if you're using a cloud service like AWS. See the [AWS note](../mixnodes) on the mixnodes configuration page.
  
Ideally you'll want to make sure that your machine speaks IPv6 in addition to IPv4, even if you don't plan to use an IPv6 address yourself. Other node operators who you may be interacting with may by using IPv6. 

---
# Page settings
layout: default
keywords:
comments: false

# Hero section
title: Overview

# Micro navigation
micro_nav: true

# Page navigation
page_nav:
    next:
        content: Nym Validators
        url: 'validators'
---

Nym is a blockchain-based privacy platform. It combines network level privacy against sophisticated end-to-end attackers, and an anonymizing layer for transactions using blinded, re-randomizable, decentralized credentials. Our goal is to allow developers to enable their applications with advanced privacy features unavailable in other systems.

At present, our running Nym testnet architecture has two main components: **Validator nodes**, and **Mixnodes**. There's also a **Nym Directory**, and a **Dashboard** providing an overview of current network status. Everything shown in the diagram is currently running on the internet, and you're welcome to try our systems out.

![overview](assets/nym-testnet.png)

## Core technologies

Nym currently consists of two core technologies:

1. a privacy enhancing signature scheme called Coconut, used in the Nym Validator nodes.
1. a mixnet, which encrypts and *mixes* network traffic through *mixnodes* so that it cannot be determined who is communicating with whom. Our mixnet is based on the *Sphinx* cryptographic packet format and the *Loopix* mixnet design.

## Validator nodes vs Mixnodes

A project wanting only private credential signing, but no network-level defences, can use Coconut credentials in the Nym Validators.

Conversely, an application that only needs to defend against network attackers can use the Nym Mixnet by itself, without the Nym Validators.

But developers that need end-to-end protection at both the network and transaction level can use both together.

At present the two parts of the system have not yet been connected together (so there is not yet the possibility to protect network traffic when generating credentials). We're working on it!

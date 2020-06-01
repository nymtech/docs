---
title: "Choose a client"
weight: 30
description: "There are multiple kinds of Nym client. Each is useful in different situations. Here's how to choose."
---

In the previous section, we got a general overview of the application flow when you're building peaps. Now it's time to understand a bit about how to structure your peap by choosing a Nym client.

## Understanding Nym clients

A large proportion of the Nym mixnet's functionality is implemented client-side, including:

1. determining network topology - what mixnodes exist, what their keys are, etc.
2. registering with a gateway
2. authenticating to a gateway
3. receiving and decrypting messages from the gateway
4. creation of layer-encrypted Sphinx packets
6. sending Sphinx packets with real messages
7. sending Sphinx packet *cover traffic* when no real messages are being sent

In the next few sections we will discuss how to integrate Nym clients into your peaps.

## Types of Nym clients

At present, there are two Nym clients: 

* the native client
* the [webassembly](https://webassembly.org/) client

You need to choose which one you want incorporate into your peap. Which one you use will depend largely on your preferred programming style and the purpose of your peap. 

### The native client

Your first option is the native client. This is a compiled program that can run on Linux, Mac OS X, and Windows machines. It runs as a persistent process on a desktop or server machine. You can connect to the native client from any language that supports websockets. 

### The webassembly client

If you're working in JavaScript, or building an [edge computing](https://en.wikipedia.org/wiki/Edge_computing) peap, you'll likely want to choose the webassembly client. We expect that many client peaps will be built using the webassembly client. It's packaged and available on the npm registry, so you can `npm install` it into your JavaScript or TypeScript application.

### Commonalities between clients

Both Nym client packages present basically the same capabilities to the privacy application developer. They need to run as a persistent process in order to stay connected and ready to receive any incoming messages from their gateway nodes. They register and authenticate to gateways, and encrypt Sphinx packets, according to the Nym Gateway Protocol (NGP). 
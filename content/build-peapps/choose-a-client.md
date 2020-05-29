---
title: "Choose a client"
weight: 30
description: "There are multiple kinds of Nym client. Each is useful in different situations. Here's how to choose."
---

In the previous section, we got a general overview of the application flow when you're building peaps. 

Let's get a bit closer to coding.

At present, there are two Nym clients: 

* the native client
* the [webassembly](https://webassembly.org/) client

You need to choose which one you want incorporate into your peap. Which one you use will depend largely on your preferred programming style and the purpose of your peap. 

If you're working in JavaScript, or building an [edge computing](https://en.wikipedia.org/wiki/Edge_computing) peap, you'll likely want to choose the webassembly client. We expect that many client peaps will be built using the webassembly client. It's packaged and available on the npm registry, so you can `npm install` it into your JavaScript or TypeScript application.

Your other option is the native client. his is a compiled program that can run on Linux, Mac OS X, and Windows machines. It runs as a persistent process on a desktop or server machine. You can connect to the native client from any language that supports websockets (so, basically all of them). 

Both Nym client packages present basically the same capabilities to the privacy application developer. They need to run as a persistent process in order to stay connected and ready to receive any incoming messages from their gateway nodes. They both register and authenticate to gateways, and encrypt Sphinx packets, according to the Nym Gateway Protocol (NGP). 

In the next few sections we will discuss how to integrate Nym clients into your peaps.
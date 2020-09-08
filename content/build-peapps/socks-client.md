---
title: "SOCKS5 client + SphinxSocks"
weight: 35
description: "How to run the Nym SOCKS5 client."
---

The Nym SOCKS5 proxy runs on your local machine and exposes a SOCKS5 network proxy on a port. You can use it just like you would any other SOCKS5 proxy: you add drop the proxy address in an application's proxy settings, and all your TCP traffic is routed through the proxy. This makes it the easiest way to enable strong network privacy in existing applications, as many apps already support SOCKS5 out of the box. In this sense it's very similary to other socks proxies.

The Nym SOCKS5 proxy, though, does something quite interesting and different. Rather than simply copy data between TCP streams and making requests directly from the machine it's running on, it does the following:

1. takes TCP data streams in, let's say from a crypto wallet
1. chops up the TCP stream into multiple Sphinx packets, assigning sequence numbers to them, while leaving the TCP connection open for more data
1. sends the Sphinx packets through the mixnet to a SphinxSocks service provider. This shuffles the packets as they transit the mixnet. 
1. SphinxSocks reassembles the original TCP stream using the sequence numbers, and makes the intended request.
1. SphinxSocks then does the whole process in reverse, chopping up the response into Sphinx packets and sending it back through the mixnet to the crypto wallet.
1. The crypto wallet receives its data, without even noticing that it wasn't talking to a "normal" SOCKS5 proxy.

In order for this to work, SphinxSocks needs to be available to take the request. As soon as we have a community member running a publicly-available SphinxSocks, we'll document its address in our Quickstart. 
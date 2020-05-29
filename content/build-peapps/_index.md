---
title: Build Privacy Applications
weight: 60
description: "Tutorials for building Privacy Enhanced Applications (or integrating existing apps with Nym)"
---

You are invited to build Privacy Enhanced Applications or peaps (pronounced *peeps*)!

Peaps are privacy respecting clients and services which use Nym network infrastructure. 

Any peap connecting to the Nym network automatically starts sending network *cover traffic* to the mixnet. It is apparent to any external network adversary that a given peap machine has connected to Nym infrastructure. Beyond that, it should not be possible to infer what activity is taking place unless there are observable network side effects (i.e. a Service Provider peap that makes network requests on behalf of a client peap).

Let's take a look at a simple application. First, we need to initialize a peap and connect it to Nym.

![send to gateway](/docs/images/application-flow/send-to-gateway.png)

At the bottom we have a peap. It consists of two parts: 

1. application specific logic (which you write in whatever language makes sense: Python, Go, C#, Java, JavaScript, Haskell, etc) in yellow
2. Nym client code in blue

Peaps have a stable, potentially long-lasting relation to a Nym node type known as a gateway. A peap registers itself with a gateway, and gets back an authentication token that it can then use to retrieve messages from the gateway.

Gateways serve a few different functions:

* they act as an end-to-end encrypted message store in case your peap goes offline.
* they do IPv6 translation for IPv4 Peaps
* they send encrypted surb-acks for potentially offline recipients, to ensure reliable message delivery
* they offer a stable addressing location for a peap, although the IP may change frequently



### Nym addresses

When the peap is initialized, it generates and stores its own public/private keypair locally. When the peap starts, it automatically connects to the Nym network and finds out what Nym infrastructure exists. It then chooses and connects to a Nym gateway node via websocket.

All Peaps in the Nym network therefore have an address, in the format `user-public-key@gateway-public-key`. 

Our peap knows its own address, because it knows its own public key and the address of its gateway. 

### Sending messages to ourself

The nym client part of the peap (in blue) accepts messages from your code (in yellow), and automatically turns it into layer-encrypted Sphinx packets. If your message is too big to fit inside on Sphinx packet, it'll be split into multiple packets with a sequence numbers to ensure reliable automatic reassembly of the full message when it gets to the recipient.

The peap has now connected to the gateway, but we haven't sent a message to ourselves yet. Let's do that now. 

![simplest message send to self](/docs/images/application-flow/simplest-request.png)

Let's say your code code pokes a message `hello world` into the nym client. The nym client automatically wraps that message up into a layer encrypted Sphinx packet, adds some routing information and encryption, and sends it to its own gateway. The gateway strips the first layer of encryption, ending up with the address of the first mixnode it should forward to, and a Sphinx packet. 

The gateway forwards the Sphinx packet containing the `hello world` message. Each mixnode in turn forwards to the next mixnode. The last mixnode forwards to the recipient gateway (in this case, our own gateway since we are sending to ourself). 

Our peap has presumably not gone offline in the short time since the message was sent. So when the gateway receives the packet, it decrypts the packet and sends the (encrypted) content back to our peap. 

The nym client inside the peap decrypts the message, and your code receives the message `hello world` again as a websocket event. 

Messages are end-to-end encrypted. Although the gateway knows our peap's IP when it connects, it's unable to read any of the message contents.

### Sending messages to other peaps

The process for sending messages to other peaps is exactly the same, you simply specify a different recipient address. Address discovery happens outside the Nym system: in the case of a Service Provider peap, the service provider has presumably advertised its own address. If you're sending to a friend of yours, you'll need to get ahold of their address out of band, maybe through a private messaging app such as Signal.


![service provider messages](/docs/images/application-flow/sp-request.png)

### Private Replies using surbs

Surbs allow peaps to reply to other peaps anonymously.

It will often be the case that a client peaps wants to interact with a Service Provider peap. It sort of defeats the purpose of the whole system if your client peap needs to reveal its own gateway public key and client public key in order to get a response from the SP peap. 

Luckily, there are Single Use Reply Blocks, or *surbs*.

A surb is a layer encrypted set of Sphinx headers detailing a reply path ending in the original peap's address. Surbs are encrypted by the client, so the SP can attach its response and send back the resulting Sphinx packet, but it never has sight of who it is replying to. 

### Offline / Online peaps

If a message arrives at a gateway address but the peap is offline, the gateway will store the messages. When the peap comes online again, it will automatically download all the messages, and they'll be deleted from the gateway disk.

If a peap is online when a message arrives for it, the message is automatically pushed to the peap down the websocket, instead of being stored to disk on the gateway. 
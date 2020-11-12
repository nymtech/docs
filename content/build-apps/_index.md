---
title: Build Apps
weight: 65
description: "Tutorials for building Privacy Enhanced Applications (or integrating existing apps with Nym)"
---

If you are a coder, we invite you to build **privacy enhanced applications** using Nym.

Nym lets you build privacy respecting clients and services which use our network infrastructure. Your apps can then connect to other apps also using the Nym network. All app-to-app communication happens over a set of cooperating networked nodes called a mixnet. 

Mixnets give strong privacy guarantees against third-party observers.

It is apparent to any external network adversary that a given machine has connected to Nym infrastructure. Beyond that, it should not be possible to infer what activity is taking place unless there are observable network side effects (i.e. a Service Provider that makes network requests on behalf of a Nym client).

We'll get into the technical details more deeply in the next few sections, but before we do that, let's take a look at the steps involved in building and using a simple application. 

### Initialization

First, we need to initialize an app and connect it to Nym.

![send to gateway](/docs/images/application-flow/send-to-gateway.png)

At the bottom we have an app. It consists of two parts: 

1. your application specific logic (which you write in whatever language makes sense: Python, Go, C#, Java, JavaScript, Haskell, etc) in yellow
2. Nym client code in blue

Nym apps have a stable, potentially long-lasting relation to a Nym node type known as a gateway. An app registers itself with a gateway, and gets back an authentication token that it can then use to retrieve messages from the gateway.

Gateways serve a few different functions:

* they act as an end-to-end encrypted message store in case your app goes offline.
* they send encrypted surb-acks for potentially offline recipients, to ensure reliable message delivery
* they offer a stable addressing location for apps, although the IP may change frequently

### Nym addresses

When the app is initialized, it generates and stores its own public/private keypair locally. When the app starts, it automatically connects to the Nym network and finds out what Nym infrastructure exists. It then chooses and connects to a Nym gateway node via websocket.

All apps in the Nym network therefore have an address, in the format `user-identity-key.user-encryption-key@gateway-identity-key`. Clients print out their address at startup.

Our app knows its own address, because it knows its own public key and the address of its gateway. 

### Sending messages to ourself

The nym client part of the app (in blue) accepts messages from your code (in yellow), and automatically turns it into layer-encrypted Sphinx packets. If your message is too big to fit inside on Sphinx packet, it'll be split into multiple packets with a sequence numbers to ensure reliable automatic reassembly of the full message when it gets to the recipient.

The app has now connected to the gateway, but we haven't sent a message to ourselves yet. Let's do that now. 

![simplest message send to self](/docs/images/application-flow/simplest-request.png)

Let's say your code code pokes a message `hello world` into the nym client. The nym client automatically wraps that message up into a layer encrypted Sphinx packet, adds some routing information and encryption, and sends it to its own gateway. The gateway strips the first layer of encryption, ending up with the address of the first mixnode it should forward to, and a Sphinx packet. 

The gateway forwards the Sphinx packet containing the `hello world` message. Each mixnode in turn forwards to the next mixnode. The last mixnode forwards to the recipient gateway (in this case, our own gateway since we are sending to ourself). 

Our app has presumably not gone offline in the short time since the message was sent. So when the gateway receives the packet, it decrypts the packet and sends the (encrypted) content back to our app. 

The nym client inside the app decrypts the message, and your code receives the message `hello world`, again as a websocket event. 

Messages are end-to-end encrypted. Although the gateway knows our app's IP when it connects, it's unable to read any of the message contents.

### Sending messages to other apps

The process for sending messages to other apps is exactly the same, you simply specify a different recipient address. Address discovery happens outside the Nym system: in the case of a Service Provider app, the service provider has presumably advertised its own address. If you're sending to a friend of yours, you'll need to get ahold of their address out of band, maybe through a private messaging app such as Signal.

![service provider messages](/docs/images/application-flow/sp-request.png)


### Clients vs Service Providers

We expect that apps will typically fall into one of two broad categories:

* client apps
* Service Providers

Client apps expose a UI for users to interact with Nym. Typically they'll run on user devices, such as laptops, phones, or tablets.

Service Providers, on the other hand, will generally run on server machines. Most Service Providers will run 24/7 and take action on behalf of anonymous client apps connected to the mixnet.

### Private Replies using surbs

Surbs allow apps to reply to other apps anonymously.

It will often be the case that a client app wants to interact with a Service Provider app. It sort of defeats the purpose of the whole system if your client app needs to reveal its own gateway public key and client public key in order to get a response from the Service Provider. 

Luckily, there are Single Use Reply Blocks, or *surbs*.

A surb is a layer encrypted set of Sphinx headers detailing a reply path ending in the original app's address. Surbs are encrypted by the client, so the Service Provider can attach its response and send back the resulting Sphinx packet, but it never has sight of who it is replying to. 

### Offline / Online Apps

If a message arrives at a gateway address but the app is offline, the gateway will store the messages for later delivery. When the recipient app comes online again, it will automatically download all the messages, and they'll be deleted from the gateway disk.

If an app is online when a message arrives for it, the message is automatically pushed to the app down the websocket, instead of being stored to disk on the gateway. 
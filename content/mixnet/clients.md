---
title: "Mixnet client"
weight: 30
---

### Clients

{{% notice info %}}
The Nym Client was built in the [Installation](../installation) section. If you haven't yet built the Nym Mixnet and want to run the code on this page, go there first.
{{% /notice %}}

From inside the `nym-mixnet` directory, the `loopix-client` binary got built to the `build` directory, so you can run it with `./build/loopix-client`:

```shell
nym-mixnet$ ./build/loopix-client
Usage: loopix-client COMMAND [OPTIONS]


  _                      _
 | |    ___   ___  _ __ (_)_  __
 | |   / _ \ / _ \| '_ \| \ \/ /
 | |___ (_) | (_) | |_) | |>  <
 |_____\___/ \___/| .__/|_/_/\_\
		  |_|            (client)



Commands:

    init        Initialise a Loopix client
    run         Run a persistent Loopix client process
    socket      Run a background Loopix client listening on a specified socket

Run "loopix-client help <command>" for more info on a specific command.
```

As you can see, there are three commands you can issue to the client.

1. init - initialize a new client instance
1. run - run a loopix client in the foreground
1. socket - run and listen on a socket for real messages as well

Let's try it out. First, you need to initialize a new client.

```
nym-mixnet$ ./build/loopix-client init --id alice
Saved generated private key to /home/you/.loopix/clients/alice/config/private_key.pem
Saved generated public key to /home/you/.loopix/clients/alice/config/public_key.pem
Saved generated config to /home/you/.loopix/clients/alice/config/config.toml
```

Have a look at the generated files if you'd like - they contain client configurations, public/private keypairs, etc.

You can run the client with user `alice` by doing this:

```shell
./build/loopix-client run --id alice
Our Public Key is: z-OQECd8VgC1BeVi6HsHMUbn3REnqZq1uXcyy9j7Hxc=

```

It doesn't look like much happened, it just sits there. But in fact, when you `run()` the client, it immediately starts generating (fake) cover traffic and sending it to the Nym Mixnet.

{{% notice info %}}
Congratulations, you have just contributed a tiny bit of privacy to the world! `<CTRL-C>` to stop the client.
{{% /notice %}}

Try stopping and starting the client a few times. If you're interested, you should see your traffic reflected in the network traffic *sent* and *received* metrics at the [Nym Dashboard](https://dashboard.nymtech.net/). Have a look on the right hand side:

![dashboard](/docs/images/dashboard.gif)

### Integrating the mixnet client in your applications

Depending on what language you're using, you can fire up the client in one of two ways.

#### In Go

If you're a Gopher, you can compile the client code into your own application in the normal Go fashion. Calling `client.Start()` and `client.SendMessage(message []byte, recipient config.ClientConfig)` will allow you to send your traffic over the Nym Mixnet. The `./build/loopix-client run --id alice` command, in fact, just calls `client.Start()`.

#### In other languages

If you're not a Gopher (go coder), don't despair. You can run the client in socket mode instead, and use either websockets or TCP sockets. For a websocket, try this:

`./build/loopix-client socket --id alice --socket websocket --port 1863`

This will start a websocket connection at `ws://localhost:1863/mix`. You can push either text or raw bytes down the websocket, and it'll be pushed to the mixnet.

For a TCP socket:

`./build/loopix-client socket --id alice --socket tcp --port 1863`


No matter whether you use `./loopix-client run`, compile the client into your code, or start a `./loopix-client socket`, the client will reach out and grab the mixnet topology, and immediately start to send fake cover traffic. When you have a real message to send, that'll be sent instead of the cover traffic.

### Understanding the client

A large proportion of the Nym Mixnet's functionality is implemented client-side, including:

1. determining network topology
1. sending Sphinx packets with real messages
1. sending Sphinx packet *cover traffic* when no real messages are being sent

#### Determining network topology

The first thing to understand is that it's the local client which picks the path that each packet will take through the mixnet topology.

When you first `run` your client, the client needs to figure what mixnodes exist, which layers they're in, and their public keys.

The client asks the Nym directory for the current mixnet topology. The client handles all this automatically, but in order to understand what's happening, you can try it yourself:

```
curl -X GET "https://directory.nymtech.net/api/presence/topology" -H  "accept: application/json" | jq   
```

This returns a JSON-formatted list of `MixNodes`, among other things:

```json
"MixNodes": [
  {
    "host": "3.9.12.238:1789",
    "pubKey": "ALf35HwBzXZXxaS6V55W7cLsx4a26AaRefinwwJHrg4=",
    "layer": 3,
    "lastSeen": 1571847181617417500
  },
  {
    "host": "35.178.213.77:1789",
    "pubKey": "KlfEn07FzcN93nMzzlsgq3wN5O1ID6O3Pd4DbezHEWo=",
    "layer": 2,
    "lastSeen": 1571847180498272500
  },
  {
    "host": "52.56.99.196:1789",
    "pubKey": "_ObRUsYnHDJOPDHXyfq5bnIoSbdn3BsSRcrLl-FCY1c=",
    "layer": 2,
    "lastSeen": 1571847180496028700
  },
  {
    "host": "18.130.86.190:1789",
    "pubKey": "dMtoH6vWDBfwjrU0EzPd-fhZDOGJazELsTp2qLyt72U=",
    "layer": 1,
    "lastSeen": 1571847181197982700
  },
  {
    "host": "3.10.22.152:1789",
    "pubKey": "03FFZ5RgfeBPmVVERenJOCLb-yXlOUtstc6izYc-wFs=",
    "layer": 1,
    "lastSeen": 1571847180994739500
  },
  {
    "host": "35.176.155.107:1789",
    "pubKey": "oaEqLzA5nUxMAqfg6yW5pneWC342uDMfVsSHxyNQ-DE=",
    "layer": 3,
    "lastSeen": 1571847181710269200
  }
],
```

The client does this when it starts. Each node reports what layer it's in, its public key, and its IP address. The client now has all the information needed to pick a path through the mixnet for each Sphinx packet, and do packet encryption.

#### Sending messages

Since it now understands the topology of the mixnet, the client can start sending traffic immediately. But what should it send?

If there's a real message to send (because you called `client.SendMessage()` or poked something down the client's socket connection), then the client will send a real message. Otherwise, the client will send cover traffic, at a rate determined in the client config file in `~/.loopix/clients/<client-id>/config.toml`

Real messages and cover traffic are both encrypted using the Sphinx packet format.

#### Sphinx packet creation

Clients create Sphinx packets. These packets are a bit complicated, but for now all you need to know is that they have the following characteristics:

1. they consist of a header and a body
1. the header contains unencrypted routing data
1. bodies are encrypted
1. bodies are padded so that they're all the same size
1. observers can't tell anything about what's inside the encrypted body
1. the body is layer-encrypted - it may contain either another sphinx packet or an unencrypted message

Now let's go build the Nym Mixnode and see what happens when a Sphinx packet hits a mixnode.

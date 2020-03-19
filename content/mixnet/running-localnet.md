---
title: "Running a devnet"
weight: 50
---

### Running a local mixnet for development

Unless you have some friends running mixnodes on other machines, running a mixnode all by itself isn't very useful if you want to poke at the system and see how it works.

It's also difficult if you're a developer and need a stable environment to work in. Although our node operators do take care to keep our testnet up and running, sometimes it's easier to run your own full setup on your own machine so you can see how the whole system works.

You can start up a full mix network, including mixnodes, and [provider](../providers) on your local machine fairly easily.

First, download, build and run the [Nym directory server](../../directory).

{{% notice warning %}}
The local network **must** be able to access a directory server running on localhost! Make sure you install and run the directory server.
{{% /notice %}}

Once you have a directory server running on port 8080, you can run the local network startup script:

`./scripts/run_local_network.sh`

By default, this will start up a 1x3 mixnet: a layered topology 1 mixnode wide and 3 layers deep, with a single provider. It's a mixnet!

You should see presence requests (a series of POST requests) hitting the directory server in its console window, telling you that (a) the directory server is receiving requests, and (b) the mixnodes are letting the directory know they're alive.

So far, it hasn't looked too spectacular. Let's exercise the network by starting the Nym client.

```shell
./target/debug/nym-client init --id zorro
./target/debug/nym-client websocket --id zorro --directory http://localhost:8080
```

Packets travel through the mixnet from the client to the provider. You're seeing loop cover traffic being automatically generated, sent through the mixnet, and hitting the store-and-forward provider, then being retrieved by the client.

```
              1         2          3
client => Mixnode1 => Mixnode2 => Mixnode3 => Provider => loop back to the client
```

It's also possible to run a larger number of mixnodes in your local mixnet:

`./scripts/run_local_network.sh 6`

This will run a 2x3 mixnet: a layered topology 2 mixnodes wide and 3 layers deep, again with a single provider receiving packets at the end.

```
                1         2          3
        /=> Mixnode1 -> Mixnode3 -> Mixnode5 \
client                X           X           => Provider
        \=> Mixnode2 -> Mixnode4 -> Mixnode6 /
```

Packets always travel forwards through mixnet layers, and layers cannot be skipped. That is:

* the client sends **only** to Mixnodes{1,2} (layer 1)
* Mixnodes {1,2} send **only** to Mixnodes {3,4} (layer 2)
* Mixnodes {3,4} send **only** to Mixnodes {5,6} (layer 3)
* Mixnodes {5,6} send **only** to provider(s).

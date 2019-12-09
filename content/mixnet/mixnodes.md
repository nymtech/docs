---
title: "Mixnodes"
weight: 40
---

### Mixnodes

{{% notice info %}}
The Nym Mixnodes were built in the [Installation](../installation) section. If you haven't yet built the Nym Mixnet and want to run the code, go there first.
{{% /notice %}}

You can run the Mix Node from the `nym-mixnet` directory like this:

```shell
nym-mixnet$ ./build/nym-mixnode
Usage: nym-mixnode COMMAND [OPTIONS]



  _ __  _   _ _ __ ___  
 | '_ \| | | | '_ \ _ \
 | | | | |_| | | | | | |
 |_| |_|\__, |_| |_| |_|
        |___/  

(mixnode)


Commands:

    run         Run a Nym mixnode

Run "nym-mixnode help <command>" for more info on a specific command.
```

Mixnodes accept Sphinx packets, shuffle packets together, and forward them onwards.

On receipt of a packet, the mixnode unwraps a layer of Sphinx encryption and assigns a delay timer based on information inside the unwrapped packet header. When the timer expires, the node forwards the packet payload (which is another Sphinx packet) to its next destination based on the routing information in the packet header. The process repeats, with layer-encrypted Sphinx packets being progressively unwrapped and forwarded, until the packet gets to its destination.

Routing and delay information is chosen by the client, rather than by mixnodes.

#### Running a single mixnode

The `run` command runs a mixnode.

```
nym-mixnet$ ./build/nym-mixnode run
[2019-10-25 14:17:55.456] metrics Mix1/newMetrics ▶ INFO - Our public key is: QtwRvtkw41AeHmfbG_NOw-9PoTAp3M8v346NN8yxk0Q=
[2019-10-25 14:17:55.623] Mix1/func1 ▶ INFO - Listening on 192.168.0.6:1789
```

`./build/nym-mixnode help run` shows available options.

#### Running a local mixnet

Unless you have some friends running mixnodes on other machines, running a mixnode all by itself isn't very useful. You can start up a full mix network, including mixnodes, and [providers](../providers), using the provided script:

`./scripts/run-network.sh`

By default, this will start up a 1x3 mixnet: a layered topology 1 mixnode wide and 3 layers deep, with a single provider. It's a mixnet.

Packets travel through the mixnet from the client to the provider.

```
              1         2          3
client => Mixnode1 => Mixnode2 => Mixnode3 => Provider
```

It's also possible to run a larger number of mixnodes in your local mixnet:

`/scripts/run_network.sh 6`

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

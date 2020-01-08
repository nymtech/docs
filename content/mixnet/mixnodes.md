---
title: "Mixnodes"
weight: 30
---

### Mixnodes

{{% notice info %}}
The Nym Mixnodes were built in the [Installation](../installation) section. If you haven't yet built Nym and want to run the code, go there first.
{{% /notice %}}

You can run the Mix Node from the `nym` top-level directory like this:

```shell
nym$ target/release/nym-mixnode


      _ __  _   _ _ __ ___
     | '_ \| | | | '_ \ _ \
     | | | | |_| | | | | | |
     |_| |_|\__, |_| |_| |_|
            |___/

             (mixnode - version 0.2.0)

    usage: --help to see available options.
```

Mixnodes accept Sphinx packets, shuffle packets together, and forward them onwards.

On receipt of a packet, the mixnode unwraps a layer of Sphinx encryption and assigns a delay timer based on information inside the unwrapped packet header. When the timer expires, the node forwards the packet payload (which is another Sphinx packet) to its next destination based on the routing information in the packet header. The process repeats, with layer-encrypted Sphinx packets being progressively unwrapped and forwarded, until the packet gets to its destination. The shuffling together of lots of packets within the nodes is what provides privacy to users.

Routing and delay information is chosen by the client, rather than by mixnodes.

#### Running a single mixnode

The `run` command runs a mixnode. You need to supply two parameters:

1. `--host <host>` needs to be an IPv4 or IPv6 address
1. `--layer <num>` needs to be an integer (1, 2, or 3) to assign the mixnode to a layer in the network topology

```shell
nym$ ./target/release/nym-mixnode run --host 127.0.0.1 --layer 1 # running bound to localhost


      _ __  _   _ _ __ ___
     | '_ \| | | | '_ \ _ \
     | | | | |_| | | | | | |
     |_| |_|\__, |_| |_| |_|
            |___/

             (mixnode - version 0.2.0)


Starting mixnode...
Public key: b-lx4nYO9VzNbjDSNpaIKClB4hF1r608C4G6VPZ82VU=
Directory server: https://directory.nymtech.net
Listening for incoming packets on 127.0.0.1:1789
```

`./target/release/nym-mixnode help run` shows available options.

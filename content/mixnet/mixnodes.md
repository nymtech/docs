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

             (mixnode - version 0.3.2)

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
nym$  ./target/release/nym-mixnode run --host 127.0.0.1 --layer 1


      _ __  _   _ _ __ ___
     | '_ \| | | | '_ \ _ \
     | | | | |_| | | | | | |
     |_| |_|\__, |_| |_| |_|
            |___/

             (mixnode - version 0.3.2)


Starting mixnode...

##### WARNING #####

You are trying to bind to 127.0.0.1 - you might not be accessible to other nodes

##### WARNING #####

Public key: rbl74MfQ-xVqtBIOq2coPGWxNztlqNDqP0R0kLB9p2g=
Directory server: https://directory.nymtech.net
Listening for incoming packets on 127.0.0.1:1789
Announcing the following socket address: 127.0.0.1:1789
```

`./target/release/nym-mixnode help run` shows available options.

If you want to run a mixnode locally, you can run a local [directory server](../directory) and bind to your loopback address (127.0.0.1) or use localhost.

{{% notice info %}}
You'll see a startup warning whenever you bind to your loopback address, because you won't be routable for clients out on the big internet.
{{% /notice %}}

However, if you are attempting to join the Nym testnet, your `--host` parameter should contain a publicly routable internet address.

#### Virtual IPs, Google, AWS, and all that

On some services (e.g. AWS, Google), the machine's available bind address is not the same as the public IP address. In this case, bind `--host` to the local machine address returned by `ifconfig`, but also specify `--announce-host` with the public IP. Please make sure that you pass the correct, routable `--announce-host`.

For example, on a Google machine, you may see the following output from the `ifconfig` command:

```
ens4: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1460
        inet 10.126.5.7  netmask 255.255.255.255  broadcast 0.0.0.0
        ...
```

The `ens4` interface has the IP `10.126.5.7`. But this isn't the public IP of the machine, it's the IP of the machine on Google's internal network. The public IP of this machine is something else, e.g. `36.68.243.18`.

`nym-mixnode run --host 10.126.5.7 --layer 1`, starts the mixnode, but no packets will be routed because `10.126.5.7` is not on the public internet.

Trying `nym-mixnode run --host 36.68.243.18 --layer 1`, you'll get back a startup error saying `AddrNotAvailable`. This is because the mixnode doesn't know how to bind to a host that's not in the output of `ifconfig`.

The right thing to do in this situation is `nym-mixnode run --host 10.126.5.7 --announce-host 36.68.243.18 --layer 1`.

This will bind the mixnode to the available host `10.126.5.7`, but announce the mixnode's public IP to the directory server as `36.68.243.18`. It's up to you as a node operator to ensure that your public and private IPs match up properly.

#### What layer should I use?

In general, we want to run a mixnet that's 3 layers deep for out testnet. Have a look at the [Nym testnet dashboard](https://dashboard.nymtech.net), and slot yourself into layer 1, 2, or 3. If you're running IPv6, please pick layer 2 or layer 3, as a lot of consumer clients still do not fully support IPv6 and may not be able to talk to your nodes.

#### Check the dashboard

Once you've started your mixnode, it will automatically show up in the [Nym testnet dashboard](https://dashboard.nymtech.net) unless you've specified a different directory server.

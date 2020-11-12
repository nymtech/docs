---
title: "Gateways"
weight: 40
description: "Gateways provide a destination for mixnet packets. Most of the internet doesn't use encrypted Sphinx packets, so the gateway acts as a destination for Sphinx traffic."
---

### Gateways

{{% notice info %}}
The Nym gateway was built in the [building nym](/docs/build-nym) section. If you haven't yet built Nym and want to run the code, go there first.
{{% /notice %}}

Gateways provide a destination for mixnet packets. Most of the internet doesn't use encrypted Sphinx packets, so the gateway acts as a destination, sort of like a mailbox, for messages.

If you would like to run a gateway for the network, please contact us.

Nym clients connect to gateways. Messages are automatically piped to connected clients and deleted from the gateway's disk storage. If a client is offline when a message arrives, it will be stored for later retrieval. When the client connects, all messages will be delivered, and deleted from the gateway's disk. As of release 0.8.x gateways use end-to-end encryption, so they cannot see the content of what they're storing for users.

When it starts up, a client registers itself with a gateway, and the gateway returns an access token. The access token plus the gateway's IP can then be used as a form of addressing for delivering packets.

The default gateway implementation included in the Nym platform code holds packets for later retrieval. For many applications (such as simple chat), this is usable out of the box, as it provides a place that potentially offline clients can retrieve packets from. The access token allows clients to pull messages from the gateway node.

You can run the gateway like this:

`nym-gateway`

Output looks like this:

```shell
$ ./nym-gateway


      _ __  _   _ _ __ ___
     | '_ \| | | | '_ \ _ \
     | | | | |_| | | | | | |
     |_| |_|\__, |_| |_| |_|
            |___/

             (gateway - version 0.9.0)

    
usage: --help to see available options.
```

`./nym-gateway init --help` shows available configuration options

#### Initializing a gateway

The `init` command sets up the gateway. You **must** supply 3 parameters:

1. `--id` a name for this gateway (determines where the config file will be saved, keep it to one word)
2. `--clients-host` needs to be an IPv4 or IPv6 address. This is the IP that the gateway will listen on for requests coming from Nym clients.
3. `--mix-host` needs to be an IPv4 or IPv6 address. This is the IP that the gateway will listen on for incoming Sphinx packets coming from the mixnet.

Example:

`./nym-gateway init --clients-host 82.32.45.6 --mix-host 82.32.45.6 --id supergateway` starts up a gateway node with default options, running on `82.32.45.6`. Note that you need to use an internet-addressable host ip. Gateways **must** also be capable of addressing IPv6. 


#### Running a gateway

The `run` command runs the gateway.

Example:

`./nym-gateway run --id supergateway`

Results in: 


```

      _ __  _   _ _ __ ___
     | '_ \| | | | '_ \ _ \
     | | | | |_| | | | | | |
     |_| |_|\__, |_| |_| |_|
            |___/

             (gateway - version 0.9.0)

    
Starting gateway supergateway...
Public key: DFvUKggcDZcqKqemK8C1KXNmBvJasp1A3ZRFdETVV9eX

Directory server [presence]: https://testnet-validator1.nymtech.net
Listening for incoming sphinx packets on 127.0.0.1:1789
Announcing the following socket address for sphinx packets: 127.0.0.1:1789
Listening for incoming clients packets on 127.0.0.1:9000
Announcing the following socket address for clients packets: ws://127.0.0.1:9000
Inboxes directory is: "~/.nym/gateways/supergateway/data/inboxes"
Clients ledger is stored at: "~/.nym/gateways/supergateway/data/client_ledger.sled"
 2020-05-26T18:40:18.713 INFO  nym_gateway::node > Starting nym gateway!
 2020-05-26T18:40:19.071 INFO  nym_gateway::node > Starting mix packet forwarder...
 2020-05-26T18:40:19.071 INFO  nym_gateway::node > Starting clients handler
 2020-05-26T18:40:19.071 INFO  nym_gateway::node > Starting mix socket listener...
 2020-05-26T18:40:19.071 INFO  nym_gateway::node > Starting client [web]socket listener...
 2020-05-26T18:40:19.072 INFO  nym_gateway::node > Starting presence notifier...
 2020-05-26T18:40:19.072 INFO  nym_gateway::node::mixnet_handling::receiver::listener 
 > Starting mixnet listener at 127.0.0.1:1789
 2020-05-26T18:40:19.072 INFO  nym_gateway::node::client_handling::websocket::listener 
 > Starting websocket listener at 127.0.0.1:9000
 2020-05-26T18:40:19.081 INFO  nym_gateway::node                                       
 > Finished nym gateway startup procedure - it should now be able to receive mix and client traffic!
```

We are currently running only one gateway, and it's going to become a bottleneck in the network. If you are interested in running a gateway for the network, please let us know. 
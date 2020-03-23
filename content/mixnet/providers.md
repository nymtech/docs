---
title: "Providers"
weight: 40
---

### Providers

{{% notice info %}}
The Nym Provider Nodes were built in the [Installation](../installation) section. If you haven't yet built the Nym Mixnet and want to run the code, go there first.
{{% /notice %}}

Providers provide a destination for mixnet packets. Most of the internet doesn't use encrypted Sphinx packets, so the provider is a natural point at which to translate Sphinx packets back into "normal" IP traffic.

When it starts up, the Mixnet [client](../clients) registers itself with a provider, and the provider returns an access token. The access token plus the provider's IP can then be used as a form of addressing for delivering packets.

The default provider implementation included in the Nym Mixnet code is a **store-and-forward** provider: a node that holds packets for later retrieval. For many applications (such as chat), this is usable out of the box, as it provides a place that potentially offline clients can retrieve packets from. The access token allows clients to pull messages from the provider node.

You can run the provider node from the top-level directory like this:

`./target/release/nym-sfw-provider`

Output looks like this:

```shell
$ ./target/release/nym-sfw-provider


      _ __  _   _ _ __ ___
     | '_ \| | | | '_ \ _ \
     | | | | |_| | | | | | |
     |_| |_|\__, |_| |_| |_|
            |___/

             (store-and-forward provider - version 0.5.0)

    
usage: --help to see available options.
```

It's worth understanding this is just a default implementation. There may be cases where you may want to make your own provider implementation with different logic.

If you're implementing a Tor-like web proxy, for instance, you might implement a provider that makes web requests and then returns a stream of Sphinx packets back to the original requester address. The original requester could then pull responses from the provider node.

Or if you are implementing cryptocurrency anonymization, you would build a provider that decrypts packets containing incoming transactions and shoots them at your blockchain of choice.

However, building your own provider implementation is potentially a big job. The simplest thing to do is to have your own entity that pulls data from the store-and-forward provider and acts upon it.

`./target/release/nym-sfw-provider init --help` shows available configuration options

#### Initializing a provider

The `init` command sets up the store-and-forward provider. You **must** supply 3 parameters:

1. `--id` a name for this provider (determines where the config file will be saved, keep it to one word)
2. `--clients-host` needs to be an IPv4 or IPv6 address. This is the IP that the provider will listen on for requests coming directly from the Nym client.
3. `--mix-host` needs to be an IPv4 or IPv6 address. This is the IP that the provider will listen on for incoming Sphinx packets coming from the mixnet.

Example:

`./target/release/nym-sfw-provider init --clients-host 127.0.0.1 --mix-host 127.0.0.1 --id superprovider` starts up a store-and-forward provider node with default options, running on `127.0.0.1`. Note that normally you will want to use an internet-addressable host. 

#### Running a provider

The `run` command runs the store-and-forward provider.

Example:

`./target/release/nym-sfw-provider run --id superprovider`

Results in: 


```
$ ./target/release/nym-sfw-provider run --id superprovider


      _ __  _   _ _ __ ___
     | '_ \| | | | '_ \ _ \
     | | | | |_| | | | | | |
     |_| |_|\__, |_| |_| |_|
            |___/

             (store-and-forward provider - version 0.5.0)

    
Starting sfw-provider superprovider...

Directory server [presence]: https://directory.nymtech.net
Listening for incoming sphinx packets on 127.0.0.1:1789
Announcing the following socket address for sphinx packets: 127.0.0.1:1789
Listening for incoming clients packets on 127.0.0.1:9000
Announcing the following socket address for clients packets: 127.0.0.1:9000
Inboxes directory is: "/home/dave/.nym/sfw-providers/superprovider/data/inboxes"
[UNIMPLEMENTED] Registered client ledger is: "/home/dave/.nym/sfw-providers/superprovider/data/client_ledger.dat"
Public key: BeFrJAhp6TLJz364nr6grfLqR5f24nuRQkYaPzcP1jMN

 2020-03-20T13:15:56.251 INFO  nym_sfw_provider::provider > Starting presence notifier...
 2020-03-20T13:15:56.251 INFO  nym_sfw_provider::provider > Starting mix socket listener...
 2020-03-20T13:15:56.251 INFO  nym_sfw_provider::provider > Starting client socket listener...
```


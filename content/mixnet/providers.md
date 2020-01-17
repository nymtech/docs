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

The default provider implementation included in the Nym Mixnet code is a **store-and-forward** provider: a node that holds packets for later retrieval. For many applications (such as chat), this is usable out of the box, as it provides a place that potentially offline clients can retrieve packets from.  The access token allows clients to pull messages from the provider node.

You can run the provider node from the top-level directory like this:

`./target/debug/nym-sfw-provider`

```shell
$ ./target/debug/nym-sfw-provider


      _ __  _   _ _ __ ___
     | '_ \| | | | '_ \ _ \
     | | | | |_| | | | | | |
     |_| |_|\__, |_| |_| |_|
            |___/

             (store-and-forward provider - version 0.3.2)

    usage: --help to see available options.
```

It's worth understanding this is just a default implementation. There may be cases where you may want to make your own provider implementation with different logic.

If you're implementing a Tor-like web proxy, for instance, you might implement a provider that makes web requests and then returns a stream of Sphinx packets back to the original requester address. The original requester could then pull responses from the provider node.

Or if you are implementing cryptocurrency anonymization, you would build a provider that decrypts packets containing incoming transaction and shoots them at your blockchain of choice.

#### Running a provider

The `run` command runs the store-and-forward provider. You need to supply two parameters:

1. `--clientHost <clientHost>` needs to be an IPv4 or IPv6 address. This is the IP that the provider will listen on for requests coming directly from the Nym client.
2. `--mixHost <mixHost>` needs to be an IPv4 or IPv6 address. This is the IP that the provider will listen on for incoming Sphinx packets coming from the mixnet.

`./target/debug/nym-sfw-provider run --clientHost 127.0.0.1 --mixHost 127.0.0.1` starts up a store-and-forward provider node with default options, running on `127.0.0.1`.

```
nym$ ./target/debug/nym-sfw-provider run --clientHost 127.0.0.1 --mixHost 127.0.0.1


      _ __  _   _ _ __ ___
     | '_ \| | | | '_ \ _ \
     | | | | |_| | | | | | |
     |_| |_|\__, |_| |_| |_|
            |___/

             (store-and-forward provider - version 0.3.2)


store_dir is: "/tmp/nym-provider/inboxes"
registered_client_ledger_dir is: "/tmp/nym-provider/registered_clients"
Listening for mixnet packets on 127.0.0.1:8085
Listening for client requests on 127.0.0.1:9000
```

`./target/debug/nym-sfw-provider help run` to see a list of available run options.

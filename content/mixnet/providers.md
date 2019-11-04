---
title: "Providers"
weight: 50
---

### Providers

{{% notice info %}}
The Nym Provider Nodes were built in the [Installation](../installation) section. If you haven't yet built the Nym Mixnet and want to run the code, go there first.
{{% /notice %}}

Providers provide a destination for mixnet packets. Most of the internet doesn't use ecnrypted Sphinx packets, so the provider is a natural point at which to translate Sphinx packets back into "normal" IP traffic.

When it starts up, the Mixnet [client](../clients) registers itself with a provider, and the provider returns an access token. The access token plus the provider's IP can then be used as a form of addressing for delivering packets.

The default provider implementation included in the Nym Mixnet code is a node that holds packets for later retrieval. For many applications (such as chat), this is usable out of the box, as it provides a place that potentially offline clients can retrieve packets from.  The access token allows clients to pull messages from the provider node.

You can run the provider node from the top-level directory like this:

`./build/loopix-provider`

```shell
nym-mixnet$ ./build/loopix-provider
Usage: loopix-provider COMMAND [OPTIONS]


  _                      _
 | |    ___   ___  _ __ (_)_  __
 | |   / _ \ / _ \| '_ \| \ \/ /
 | |___ (_) | (_) | |_) | |>  <
 |_____\___/ \___/| .__/|_/_/\_\
		  |_|            (provider)



Commands:

    run         Run a Loopix provider for offline storage

Run "loopix-provider help <command>" for more info on a specific command.
```

It's worth understanding this is just a default implementation. There may be cases where you may want to make your own provider implementation with different logic.

If you're implementing a Tor-like web proxy, for instance, you might implement a provider that makes web requests and then returns a stream of Sphinx packets back to the original requester address. The original requester could then pull responses from the provider node.

Or if you are implementing cryptocurrency anonymization, you would build a provider that decrypts packets containing incoming transaction and shoots them at your blockchain of choice.

#### Running a provider

`./build/loopix-provider run` starts up a provider node with default options.

```
nym-mixnet$ ./build/loopix-provider run
[2019-10-25 14:42:37.010] Provider/func1 ▶ INFO - Listening on 192.168.0.6:1789
```

`./build/loopix-provider help run` to see a list of available run options.

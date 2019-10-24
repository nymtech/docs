---
title: "Storage Nodes"
weight: 50
---

### Storage nodes

{{% notice info %}}
The Nym Storage Nodes were built in the [Installation](../installation) section. If you haven't yet built the Nym Mixnet and want to run the code, go there first.
{{% /notice %}}

You can run the Storage node from the `nym-mixnet` directory like this:

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

Loopix providers, or storage nodes, provide a destination for mixnet packets. When they start up, a Mixnet [client](../clients) registers itself with a storage node, generating an access token allowing the client to pull messages from the storage node. The default storage node implementation included in the current Nym Mixnet holds packets for later retrieval.

The provider may choose to:

* forward packets to the destination itself - this would make sense in the case of e.g. the Bitcoin blockchain
* store packets for later retrieval by potentially offline clients - this would make sense for e.g. a chat application

TODO: finish the first cut of this one

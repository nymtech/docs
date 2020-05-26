---
title: Run a mixnode
weight: 10
description: "How to join the Nym network by your running your own mixnode"
---

{{% notice info %}}
The Nym mixnode was built in the [Quickstart](/docs/quickstart). If you haven't yet built Nym and want to run the code, go there first.
{{% /notice %}}

Once you've built the code, and want to join the Nym testnet, you can do it quite easily. 

Copy the `nym-mixnode` binary from the `target/release` directory up to your server.

Initialize a mixnode:

```
nym-mixnode init --id winston-smithnode --host 167.70.75.75 --layer 1 --location YourCity
```

The `--location` flag is optional but helps us debug the testnet. 

To participate in the Nym testnet, `--host` must be publicly routable on the internet. It can be either Ipv4 or IPv6.

Run the mixnode: 

`nym-mixnode run --id winston-smithnode`


You should see a nice clean startup: 

```
     | '_ \| | | | '_ \ _ \
     | | | | |_| | | | | | |
     |_| |_|\__, |_| |_| |_|
            |___/

             (mixnode - version 0.7.0)

    
Starting mixnode winston-smithnode...

Directory server [presence]: https://directory.nymtech.net
Directory server [metrics]: https://directory.nymtech.net
Listening for incoming packets on 167.70.75.75:1789
Announcing the following socket address: 167.70.75.75:1789
Public key: HHWAJ1zwpbb1uPLCvoTCUrtyUEuW9KKbUUnz3EUF1Xd9

 2020-05-05T16:01:07.802 INFO  nym_mixnode::node > Starting nym mixnode
 2020-05-05T16:01:08.135 INFO  nym_mixnode::node > Starting packet forwarder...
 2020-05-05T16:01:08.136 INFO  nym_mixnode::node > Starting metrics reporter...
 2020-05-05T16:01:08.136 INFO  nym_mixnode::node > Starting socket listener...
 2020-05-05T16:01:08.136 INFO  nym_mixnode::node > Starting presence notifier...
 2020-05-05T16:01:08.136 INFO  nym_mixnode::node > Finished nym mixnode startup procedure - it should now be able to receive mix traffic!
```

If everything worked, you'll see your node running at https://dashboard.nymtech.net. 

Note that your node's public key is displayed during startup, you can use it to identify your node in the list.

Now that you've got it running, have a look at the [mixnode docs](../../mixnet/mixnodes) to find our more about configuration options. There are also some tips for running on AWS and other cloud providers, some of which require minor additional setup.

{{% notice info %}}
If you run into trouble, please ask for help in the channel **nymtech.friends#general** on [KeyBase](https://keybase.io).
{{% /notice %}}
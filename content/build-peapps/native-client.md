---
title: "Native client"
weight: 40
description: "How to build and run the Nym mixnet-client."
---

### Nym Native Client



{{% notice info %}}
The Nym Client was built in the [Installation](../installation) section. If you haven't yet built Nym and want to run the code on this page, go there first.
{{% /notice %}}

From inside the `nym` directory, the `nym-client` binary got built to the `./target/release/` directory. You can run it like this:

`./target/release/nym-client`

```shell
$ ./target/release/nym-client 


      _ __  _   _ _ __ ___
     | '_ \| | | | '_ \ _ \
     | | | | |_| | | | | | |
     |_| |_|\__, |_| |_| |_|
            |___/

             (client - version 0.7.0)

    
usage: --help to see available options.
```

There are two commands you can issue to the client.

1. `init` - initialize a new client instance. Requires `--id clientname` parameter.
2. `run` - run a mixnet client process. Requires `--id clientname` as a parameter

Let's try it out. First, you need to initialize a new client.

`./target/release/nym-client init --id alice`

```
      _ __  _   _ _ __ ___
     | '_ \| | | | '_ \ _ \
     | | | | |_| | | | | | |
     |_| |_|\__, |_| |_| |_|
            |___/

             (client - version 0.7.0)

    
Initialising client...
 2020-05-26T18:45:32.098 INFO  pemstore::pemstore > Written private key to "~/.nym/clients/alice/data/private_identity.pem"
 2020-05-26T18:45:32.099 INFO  pemstore::pemstore > Written public key to "~/.nym/clients/alice/data/public_identity.pem"
Saved mixnet identity keypair
Saved configuration file to "~/.nym/clients/alice/config/config.toml"
Unless overridden in all `nym-client run` we will be talking to the following gateway: BfsNG1WGzLYNQwmSoZas969KFnXyKY9pbsQqSDmZWdyQ...
using optional AuthToken: "9XSGi1vR1Xy1HbSaPKNzwQ8gqLgqbDDVudYFr5Khi2xq"
Client configuration completed.
```

Have a look at the generated files if you'd like - they contain the client name, public/private keypairs, etc.

You can run the client for user `alice` by doing this:

`./target/release/nym-client run --id alice`

Output should look something like this:

```shell
$ ./target/release/nym-client run --id alice


      _ __  _   _ _ __ ___
     | '_ \| | | | '_ \ _ \
     | | | | |_| | | | | | |
     |_| |_|\__, |_| |_| |_|
            |___/

             (client - version 0.7.0)


Starting websocket on port: 9001
Listening for messages...
Starting nym client
Using directory server: "https://directory.nymtech.net"
```

When you run the client, it immediately starts generating (fake) cover traffic and sending it to the Nym testnet.

{{% notice info %}}
Congratulations, you have just contributed a tiny bit of privacy to the world! `<CTRL-C>` to stop the client.
{{% /notice %}}

Try stopping and starting the client a few times. If you're interested, you should see your traffic reflected in the network traffic *sent* and *received* metrics at the [Nym Dashboard](https://dashboard.nymtech.net/). Have a look on the right hand side:

![dashboard](/docs/images/dashboard.gif)


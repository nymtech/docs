---
title: Run a validator
weight: 20
description: "How to join the Nym network with a validator node"
---

{{% notice info %}}
The Nym validator was built in the [Quickstart](https://nymtech.net/docs/quickstart). If you haven't yet built Nym and want to run the code, go there first.
{{% /notice %}}

Nym validators will do two jobs:

1. collaborate with each other to maintain a blockchain, using [Tendermint](https://tendermint.com)
2. hand out Coconut credentials to clients

To start one on a public facing internet server, do the following:

```
nym-validator init --id my-validator
nym-validator run --id my-validator
```

A successful start looks like this: 

```
      _ __  _   _ _ __ ___
     | '_ \| | | | '_ \ _ \
     | | | | |_| | | | | | |
     |_| |_|\__, |_| |_| |_|
            |___/

             (validator - version 0.7.0-dev)

    
Starting validator my-validator...
Validator startup complete.
* starting REST API on http://localhost:3000
* starting Tendermint abci
```

Then start Tendermint, which handles the blockchain:

```
tendermint init
tendermint node
```

When you run the `tendermint node` command, the blockchain will start up and attach to the Nym validator code. You will see additional messages when this happens:

```
 2020-05-05T17:30:42.143 INFO  abci::server > Got connection! TcpStream { addr: V4(127.0.0.1:26658), peer: V4(127.0.0.1:44870), fd: 100 }
 2020-05-05T17:30:42.143 INFO  abci::server > Got connection! TcpStream { addr: V4(127.0.0.1:26658), peer: V4(127.0.0.1:44872), fd: 101 }
 2020-05-05T17:30:42.144 INFO  abci::server > Got connection! TcpStream { addr: V4(127.0.0.1:26658), peer: V4(127.0.0.1:44874), fd: 102 }

```

You will need to cooperate with other validator node operators to join the testnet. Unfortunately this requires some manual setup. Please visit us in the channel **nymtech.friends#general** on [KeyBase](https://keybase.io) to talk about getting set up as a validator.
---
title: "Nym Gateway Protocol"
weight: 50
description: "A description of the Nym Gateway Protocol."
---

Typically you'll never see these messages, you can just call the appropriate methods and your client will take care of formatting and sending them. But it can be handy to understand what's going on inside the client.

get topology - recipient: directory (will be validator set soon)
register - recipient: gateway
authenticate - recipient: gateway



#### Determining network topology

The first thing to understand is that it's the local client which picks the path that each packet will take through the mixnet topology.

When you first run your client, the client needs to figure what mixnodes exist, which layers they're in, and their public keys.

The client asks the Nym [directory](../../directory) for the current mixnet topology. The client handles all this automatically, but in order to understand what's happening, you can try it yourself:

```bash
curl -X GET "https://directory.nymtech.net/api/presence/topology" -H  "accept: application/json" | jq
```

This returns a JSON-formatted list of Nym nodes.

TODO get the most up to date one

```json
"MixNodes": [
  {
    "host": "52.56.99.196:1789",
    "pubKey": "_ObRUsYnHDJOPDHXyfq5bnIoSbdn3BsSRcrLl-FCY1c=",
    "layer": 2,
    "lastSeen": 1572258570490299400
  },
  {
    "host": "18.130.86.190:1789",
    "pubKey": "dMtoH6vWDBfwjrU0EzPd-fhZDOGJazELsTp2qLyt72U=",
    "layer": 1,
    "lastSeen": 1572258571193777000
  },
  {
    "host": "3.10.22.152:1789",
    "pubKey": "03FFZ5RgfeBPmVVERenJOCLb-yXlOUtstc6izYc-wFs=",
    "layer": 1,
    "lastSeen": 1572258570994450200
  },
  {
    "host": "35.176.155.107:1789",
    "pubKey": "oaEqLzA5nUxMAqfg6yW5pneWC342uDMfVsSHxyNQ-DE=",
    "layer": 3,
    "lastSeen": 1572258571709773800
  },
  {
    "host": "3.9.12.238:1789",
    "pubKey": "ALf35HwBzXZXxaS6V55W7cLsx4a26AaRefinwwJHrg4=",
    "layer": 3,
    "lastSeen": 1572258571616835600
  },
  {
    "host": "35.178.213.77:1789",
    "pubKey": "KlfEn07FzcN93nMzzlsgq3wN5O1ID6O3Pd4DbezHEWo=",
    "layer": 2,
    "lastSeen": 1572258570492776400
  }
],
"MixProviderNodes": [
  {
    "host": "35.178.212.193:1789",
    "pubKey": "R_rGKmwelVAVRpicMwMIJwsHvdYHMNfcItPwNipu5GQ=",
    "registeredClients": [
      {
        "pubKey": "u7UTjC3UNXdz0HsjMKoxozzbvXyi3KrEvl8BxNNPcAM="
      },
     ...
    ],
    "lastSeen": 1572258572070089000
  },
  {
    "host": "3.8.176.11:1789",
    "pubKey": "XiVE6xA10xFkAwfIQuBDc_JRXWerL0Pcqi7DipEUeTE=",
    "registeredClients": [
      {
        "pubKey": "HGTg5XPWe4eiluFKTnC958PuGUSipjLcIeFdLi6zsww="
      },
      ...
    ],
    "lastSeen": 1572258571843881700
  }
],
...
```

The client does this when it starts. Each mixnode reports what layer it's in, its public key, and its IP address. Provider nodes do the same.

The client now has all the information needed to pick a path through the mixnet for each Sphinx packet, and do packet encryption.




Since it now understands the topology of the mixnet, the client can start sending traffic immediately. But what should it send?

If there's a real message to send (because you poked something down the client's inbound socket connection), then the client will send a real message. Otherwise, the client sends cover traffic.

Real messages and cover traffic are both encrypted using the Sphinx packet format, so that they're indistinguishable from each other.

#### Sphinx packet creation

Clients create Sphinx packets. These packets are a bit complicated, but for now all you need to know is that they have the following characteristics:

1. they consist of a header and a body
1. the header contains unencrypted routing data
1. bodies are encrypted
1. bodies are padded so that they're all the same size
1. observers can't tell anything about what's inside the encrypted body
1. the body is layer-encrypted - it may contain either another sphinx packet or a payload message
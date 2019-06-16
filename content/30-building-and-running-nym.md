---
weight: 30
title: Building and Running Nym
---

# Building and Running Nym

In the preceding Quickstart, there was a speedy succession of commands to build and run Nym inside docker containers, then hit the containers with the Nym client. If you were able to run all of them without errors, you have made your first Nym request.

But what did all of this do? What are the moving parts of a Nym-based system?

## Building

`make localnet-build` builds out a configuration directory for a Nym testnet that runs on your local machine. Listing the directory structure gives you this layout of files and directories:

> List the `build` directory using the `tree` command. If you don't have that installed, just poke around using `ls`.

```bash
tree build/

build/
├── ethereum-watchers
│   ├── watcher1
│   │   ├── config.toml
│   │   └── watcher.key
│   └── watcher2
│       ├── config.toml
│       └── watcher.key
├── issuers
│   ├── issuer1
│   │   ├── coconutkeys
│   │   │   ├── threshold-secretKey-id=1-attrs=5-n=5-t=3.pem
│   │   │   └── threshold-verificationKey-id=1-attrs=5-n=5-t=3.pem
│   │   └── config.toml
│   ├── issuer2
│   │   ├── coconutkeys
│   │   │   ├── threshold-secretKey-id=2-attrs=5-n=5-t=3.pem
│   │   │   └── threshold-verificationKey-id=2-attrs=5-n=5-t=3.pem
│   │   └── config.toml
│   └── issuer3
│       ├── coconutkeys
│       │   ├── threshold-secretKey-id=3-attrs=5-n=5-t=3.pem
│       │   └── threshold-verificationKey-id=3-attrs=5-n=5-t=3.pem
│       └── config.toml
├── nodes
│   ├── config
│   │   └── config.toml
│   ├── data
│   ├── node0
│   │   ├── config
│   │   │   ├── config.toml
│   │   │   ├── genesis.json
│   │   │   ├── node_key.json
│   │   │   └── priv_validator_key.json
│   │   └── data
│   │       └── priv_validator_state.json
│   ├── node1
│   │   ├── config
│   │   │   ├── config.toml
│   │   │   ├── genesis.json
│   │   │   ├── node_key.json
│   │   │   └── priv_validator_key.json
│   │   └── data
│   │       └── priv_validator_state.json
│   ├── node2
│   │   ├── config
│   │   │   ├── config.toml
│   │   │   ├── genesis.json
│   │   │   ├── node_key.json
│   │   │   └── priv_validator_key.json
│   │   └── data
│   │       └── priv_validator_state.json
│   └── node3
│       ├── config
│       │   ├── config.toml
│       │   ├── genesis.json
│       │   ├── node_key.json
│       │   └── priv_validator_key.json
│       └── data
│           └── priv_validator_state.json
└── providers
    ├── provider1
    │   ├── accountKey
    │   │   └── provider.key
    │   ├── config.toml
    │   └── issuerKeys
    │       ├── threshold-verificationKey-id=1-attrs=5-n=5-t=3.pem
    │       ├── threshold-verificationKey-id=2-attrs=5-n=5-t=3.pem
    │       ├── threshold-verificationKey-id=3-attrs=5-n=5-t=3.pem
    │       ├── threshold-verificationKey-id=4-attrs=5-n=5-t=3.pem
    │       └── threshold-verificationKey-id=5-attrs=5-n=5-t=3.pem
    └── provider2
        ├── accountKey
        │   └── provider.key
        ├── config.toml
        └── issuerKeys
            ├── threshold-verificationKey-id=1-attrs=5-n=5-t=3.pem
            ├── threshold-verificationKey-id=2-attrs=5-n=5-t=3.pem
            ├── threshold-verificationKey-id=3-attrs=5-n=5-t=3.pem
            ├── threshold-verificationKey-id=4-attrs=5-n=5-t=3.pem
            └── threshold-verificationKey-id=5-attrs=5-n=5-t=3.pem
```

As you can see, the config directory contains configuration files,  as well as private and public keys for multiple components.

The components are as follows:

* `ethereum-watchers` watch the Ethereum blockchain for interesting transactions (such as a user piping Nym ERC20 tokens into Nym).
* `issuers` are Coconut credential issuing authorities.
* `nodes` are Tendermint blockchain nodes.
* `providers` are (dummy) external service providers.

## Running Nym in Docker

`docker-compose up -d`

1. starts Ethereum watchers, which point at the Ropsten testnet
1. starts issuing authorities
1. starts Tendermint nodes
1. starts dummy service providers

You can get an idea of what infrastructure you're now running by using `docker ps`.

> Truncated output of `docker ps`

```bash
docker ps
IMAGE               COMMAND                  PORTS                                                NAMES
88d0b7d0b4ba        "/app/provider -f /p…"   0.0.0.0:4100->4000/tcp, 0.0.0.0:5100->5000/tcp       provider1
88d0b7d0b4ba        "/app/provider -f /p…"   0.0.0.0:4101->4000/tcp, 0.0.0.0:5101->5000/tcp       provider2
298f6b896c69        "/app/issuer -f /iss…"   0.0.0.0:4000->4000/tcp, 0.0.0.0:5000->5000/tcp       issuer1
298f6b896c69        "/app/issuer -f /iss…"   0.0.0.0:4001->4000/tcp, 0.0.0.0:5001->5000/tcp       issuer2
298f6b896c69        "/app/issuer -f /iss…"   0.0.0.0:4002->4000/tcp, 0.0.0.0:5002->5000/tcp       issuer3
2d9126a7090b        "/app/nymnode"           0.0.0.0:26659->26656/tcp, 0.0.0.0:26660->26657/tcp   node1
2d9126a7090b        "/app/nymnode"           0.0.0.0:26663->26656/tcp, 0.0.0.0:26664->26657/tcp   node3
2d9126a7090b        "/app/nymnode"           0.0.0.0:26656-26657->26656-26657/tcp                 node0
2d9126a7090b        "/app/nymnode"           0.0.0.0:26661->26656/tcp, 0.0.0.0:26662->26657/tcp   node2
```

## Your first Nym credential request

So now all the infrastructure is running. How can you make a request for a credential?

Download and run the Nym sample client. Go to <TODO Jędrzej please put the URL here>, download the sample `nymclient`, and put it somewhere in your `PATH`. Then run:

`./nymclient -f localnetdata/localclient/config.toml`

When the client starts running, the following actions occur:

### Initialization

1. the client connects to the Ethereum Ropsten testnet
1. the client connects to the Nym Tendermint blockchain

### Piping currency into Nym

1. the client transfers 1 Nym ERC20 token from its own Ethereum address into the Nym "pipe" account. The "from" account is specified in the file `localnetdata/localclient/clientAccount.key`
1. the Nym Ethereum watcher, meanwhile, has been watching the Ethereum chain for any incoming transactions
1. when a threshold number of Watchers have notified Tendermint that they have seen incoming Nym tokens, the incoming tokens are piped into the Tendermint blockchain for use in the Nym system.
1. the user's account in Nym is credited as having 1 Nym token available.

### Getting partial Nym credentials to spend on a privacy-enabled service

1. the user decides to get a credential for 1 Nym token so that it can be spent.
1. the Nym client generates some cryptographic material, and sends it to the Tendermint chain. The issuers monitor this chain and store partial credentials in their datastores. The client may query for it at any future time to retrieve it. Note: anyone may retrieve any credential, but only the client holding the secret for a given credential may use it.
1. the client queries the issuing authorities and retrieves the each partial credential from as many issuing authorities as desired
1. the client recombines the partial credentials, using a secret key generated specifically for this set of partial credentials

The client has retrieved a partial credential from multiple issuing authorities. At this point, those authorities are still able to identify which client requested the credential, so they could potentially identify the client if it tries to spend the credential. To fix this, the client needs to rerandomize.

### Rerandomizing  and spending the credential

1. the client re-rerandomizes the assembled credential, outputting a fresh credential containing the same cryptographic claims as the original but which is not linked to the original.
1. the user can now spend this new, re-randomized credential with a service provider
1. the user's client sends the credential to a service provider (SP), along with some extra cryptographic material binding the credential to the SP and providing defense against credential replay attacks.

### Validating the credential

Validation of the credential being presented by the user is done by the Service Provider, and the Issuing Authorities (IAs).

1. the SP receives the credential.
1. the SP does local validation of the credential using the verification key of the relevant Issuing Authorities.
1. the SP sends the credential to the Tendermint nodes to redeem it.
1. the Tendermint nodes redeem the credential, crediting the SP's account with 1 Nym. This is written to the chain to defend against double spending attacks.
1. at this point, the SP has been paid 1 Nym. The user's client is now free to use the service provided by the SP.

## Dummy Service Provider response

In in a production system, Service Providers will be run by third parties. But in order to demonstrate the system, we've built a dummy service provider into a Docker container so that we

1. the SP returns "true" to the client if the redemption request succeeded, and "false" if the redemption request failed.
1. the client receives the response.

## Service logging

There is quite a bit going on in the above flow. To see what happening inside each component when `nymclient` makes its request, you may want to view the logs for each different component.

To get a list of containers, run `docker ps`. Then attach to whichever containers you want to see logs for, e.g:

* `docker attach issuer1`
* `docker attach node0`
* `docker attach provider1`
* `docker attach watcher1`

---
# Page settings
layout: default
keywords:
comments: false

# Hero section
title: Mixnodes
description: Network-level privacy

# Micro navigation
micro_nav: true

# Page navigation
page_nav:
    prev:
      content: Validators
      url: '../mixnodes'
    next:
      content: TODO
      url: '#'
---


## Directory

Note that in both the Nym Validators and Nym Mixnet discussions above, quite a bit is assumed. How does the client know which nodes exist, and what their IP addresses are? How does it find out their public keys so it can encrypt messages to them, and verify that responses came from them? How can we measure the overall throughput?

The Nym Directory handles all of these concerns:

* presence - each Nym node sends a heartbeat message to the Directory every few seconds so we know what's running
* public key infrastructure (PKI) - each node sends its public key as an identifier with the presence messages
* metrics - if desired, Nym Mixnodes can optionally send information about packets sent/received to the Nym Directory, so we can monitor performance in the testnet. If you would like to implement any Nym Mixnet visualizations, there's a websocket available for metrics at [wss://directory.nymtech.net/ws](wss://directory.nymtech.net/ws)

The Nym Directory is accessible by a simple REST API. Swagger docs are at [https://directory.nymtech.net/swagger/index.html](https://directory.nymtech.net/swagger/index.html)

As you'll note from the architecture diagram, the Nym Directory is currently centralised. This is not desirable as it's a single point of failure (or attack) for the system as a whole.

While we're still in early testnet mode, the Nym Directory works well enough to bootstrap the testnet into existence.

Once our mixnet Quality of Service system, and Proof of Stake system, is running, we will eventually move the functionality of the Directory into the Nym Validator nodes.

## Dashboard

You can see a simple representation of the overall Nym network at [https://dashboard.nymtech.net/](https://dashboard.nymtech.net/). This also shows you a live reading of traffic metrics being sent over the mixnet. The **sent** and **received** numbers on each mixnode shows how many packets it has received and sent in the past 1 second.

## Other components

Other components are going to be necessary in the full system, including:

### Proof of Stake

Nym nodes will rely on a Proof of Stake (PoS) mechanism for both sybil defenses (Validators) and quality of service (Mixnodes). This not yet written, primarily because measuring quality of service in order to achieve mixnode stake slashing in a trustless environment was an unsolved problem until very recently (see below).

### Quality of Service Monitoring

The Nym Mixnodes currently incorporate a simple, but individualistic, mechanism for determining quality of service. Connected clients periodically send "loop" messages to themselves. This provides network cover traffic and also allows each client to check that its messages are getting through.

This works reasonably well for a single client, but it breaks down when we want to check quality of service across the system as a whole, in a trustless environment. A client reporting that its messages never made it past Mixode A could in fact be an attacker who wants to knock the honest Mixnode A out of the network.

We have come up with a solution to this problem, allowing auditing of mixnode behaviour across the system as a whole. Once that's working, we will have the ability to stake slash in cases where a Nym Mixnode fails to provide good service.

# Building and Running Nym

Split this up, the page is pretty long now.

## Install and run in Docker

* Install Docker.
* Install Make.
* `rm -rf build` if you've previously installed Nym.
* `git clone` the code.
* `cd nym`
* `make localnet-build` builds the config directories and docker images
* `docker-compose up -d`

All components should now be running (please file a bug report if not).

## Your first Nym Validator request

Go to [TODO Jędrzej please put the URL here], download the sample `nymclient`, and put it somewhere in your `PATH`.

Now run `./nymclient -f localnetdata/localclient/config.toml`.

In the preceding Quickstart, there was a speedy succession of commands to build and run Nym inside docker containers, then hit the containers with the Nym client. If you were able to run all of them without errors, you have made your first Nym request.

But what did all of this do? What are the moving parts of a Nym-based system?

## Building

`make localnet-build` builds out a configuration directory for a Nym testnet that runs on your local machine. Listing the directory structure gives you this layout of files and directories. Use `tree build/` to list the directory tree.

> List the `build` directory using the `tree` command. If you don't have `tree` installed, just poke around using `ls`.

```bash
$ tree build/
```

The config directory contains configuration files,  as well as private and public keys for multiple components.

The components are as follows:

* `ethereum-watchers` watch the Ethereum blockchain for interesting transactions (such as a user piping Nym ERC20 tokens into Nym).
* `issuers` are Coconut credential issuing authorities.
* `nodes` are Tendermint blockchain nodes.
* `verifiers` are Nym credential verifiers validating any credentials service providers want to deposit.
* `providers` are (dummy) external service providers.

## Running Nym in Docker

`docker-compose up -d`

1. starts Ethereum watchers, which point at the Ropsten testnet
1. starts issuing authorities
1. starts Tendermint nodes
1. starts credential verifiers
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

Download and run the Nym sample client. Go to [release page](https://github.com/nymtech/nym/releases/download/v0.9.1/nymclient-linux-x86_64), download the sample `nymclient`, and put it somewhere in your `PATH`. Then run:

`nymclient -f $GOPATH/src/github.com/nymtech/nymlocalnetdata/localclient/config.toml`.

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
1. the Credential Verifiers, meanwhile, monitor this chain and validate credential in redeem requests
1. when a threshold number of Verifiers have notified Tendermint that given credential was valid, the Tendermint nodes redeem the credential, crediting the SP's account with 1 Nym. This is written to the chain to defend against double spending attacks.
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
* `docker attach verifier1`

# Developer documentation

## Pre-requisites

To run the code, follow the standard Go installation procedure as described in [https://golang.org/doc/install](https://golang.org/doc/install).

All of the required dependencies are attached in the vendor directory.

## Test

In order to run tests, simply use the following:

`go test -v ./...`

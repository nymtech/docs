---
# Page settings
layout: default
keywords:
comments: false

# Hero section
title: Validators
description: Transaction-level privacy using Coconut

# Micro navigation
micro_nav: true

# Page navigation
page_nav:
    prev:
      content: Overview
      url: '/index'
    next:
      content: Mixnodes
      url: '/mixnodes'
---

[Nym Validators](https://github.com/nymtech/nym-validator) provide privacy-enhanced credentials based on the testimony of a set of decentralized, blockchain-based issuing authorities.

Nym Validators use a [signature scheme](https://en.wikipedia.org/wiki/Digital_signature) called [Coconut](https://arxiv.org/abs/1802.07344). This allows users of the system to generate credentials through decentralised authorities, then use them with service providers.

Like centralised credentials, Nym credentials can be signed with a secret key and later verified by anybody with the corresponding public key. But Nym credentials are much more powerful than "normal" signature schemes like standard RSA or DSA.

Specifically, Coconut is a blinded, re-randomizable, selective disclosure threshold credential signature scheme. That's quite a mouthful, so let's break it all down into digestible chunks.

Let's say you have a message in hand. In addition to the normal `sign(message, secretKey)` and `verify(message, publicKey)` functions present in other signature schemes, Coconut adds the following:

1) *[Blind signatures](https://en.wikipedia.org/wiki/Blind_signature)* - disguises message content so that the signer can't see what they're signing. This defends users against signers: the entity that signed can't identify the user who created a given credential, since they've never seen the message they're signing before it's been *blinded* (turned into gobbledygook). Coconut uses zero-knowledge proofs so that the signer can sign confidently without seeing the unblinded content of the message.

2) *Re-randomizable signatures* - take a signature, and generate a brand new signature that is valid for the same underlying message. The new bitstring in the re-randomized signature is equivalent to the original signature but not linkable to it. So a user can "show" a credential multiple times, and each time it appears to be a new credential, which is unlinkable to any previous "show". But the underlying content of the re-randomized credential is the same (including for things like double-spend protection). This once again protects the user against the signer, because the signer can't trace the signed message that they gave back to the user when it is presented. It also protects the user against the relying party that accepts the signed credential. The user can show re-randomized credentials repeatedly, and although the underlying message is the same in all cases, there's no way of tracking them by watching the user present the same credential multiple times.

3) *Selective disclosure of attributes* - allows someone with the public key to verify some, but not all, parts of a message. So you could for instance selectively reveal parts of a signed message to some people, but not to others. This is a very powerful property of Coconut, potentially leading to diverse applications: anonymous voting systems, selective revelation of medical data, etc.

4) *[Threshold issuance](https://en.wikipedia.org/wiki/Threshold_cryptosystem)* - allows signature generation to be split up across multiple nodes and decentralised, so that either all signers need to sign (*n of n* where *n* is the number of signers) or only a threshold number of signers need to sign a message (*t of n* where *t* is the threshold value).

Taken together, these properties provide excellent privacy for Nym users when it comes to generating and using signatures for cryptographic claims.

### How do Nym Validators work?

If you are a coder and interested in trying it, you can download, build, and run Nym Validator code today. We are also running a small and somewhat creaky testnet publicly. Nym Validators form a network of decentralized nodes:

![validators](../assets/validators.png)

Here's the general flow.

A client (in purple at the bottom) has a message `m` in hand. The message contains a cryptographic claim. The client *blinds* the message (to protect the privacy of message content), so now it's got `Blinded(m)`. It then connects to Nym Validators, presents `Blinded(m)`, and asks for a set of signed threshold credentials.

Validators work together to verify messages, communicating through [Tendermint's](https://tendermint.com/) consensus protocol.

If the blinded message `Blinded(m)` is valid, each validator issues a partial credential. Assuming the signature threshold is met, the client then assembles all of the partial credentials into a single credential `Signed(m)`. From a privacy perspective, this is pretty good: all Nym Validators would need to collude in order to de-anonymize the user. And the validators have never seen the actual message `m` they've signed, so that's private too.

But it's not perfect, insofar as it's hard but not impossible for validators to collude. So the client can now call `randomize(Cm)`. This converts `Signed(m)` into a brand-new credential `Signed(m)'`. The magic part: the underlying message `m` in both `Signed(m)` and `Signed(m)'` can both still be verified independently of which credential it's in. `m` is always `m`, even if it's contained in a new, re-randomized signature. This means that in the context of crypto-currency transaction privacy, double-spend protection works.

Re-randomization is cryptographically inexpensive, so you can happily re-randomize every time you want to show the credential. This makes it impossible for anyone to identify a user by tracing where they've previously generated or used a specific credential. Calling `randomize(Signed(m))` before you show a credential makes each show unlinkable to all previous shows.

At this point, the client has `Signed(m)'`, which is essentially a privacy-enhanced bearer token signed by the Nym Validators. The meaning of this depends on the content of `m`. It might say *I'm able to pay 2 BTC.* It might say *I haven't voted in the election yet, here's my vote.* Or it might say *I'm over the age of 18, let me into the pub.*

The re-randomized credential can then be passed to Service Providers (SPs). SPs are entities external to Nym, which are able to accept signed Nym Credentials and present them to Nym Validators. The Nym Validators will then take appropriate action based on the nature of the presented credential.

So much for the general flow. Now to the specifics of what's running now.

In the current Nym Validators testnet, we focus primarily on making blockchain transactions private. To demonstrate the technology, we've set up a Nym ERC20 coin running on the Ethereum Ropsten testnet.

The Nym client sends a Nym ERC20 coin to a specific Ethereum address. This locks up the ERC20 coin until it's released by action of the Nym Validators.

The client then goes through the credential assembly dance. It creates a cryptographic claim asserting that it transferred Nym ERC20 token(s) into Nym, and sends it to the validators to sign. Validators monitor the Ethereum blockchain, watching for Nym coin transactions, so they're able to verify what happened, and decide whether the client has in fact transferred value, and whether the client has overspent (in which case the credential creation request will be denied).

Right now, Service Providers are just dummy SPs which demonstrate that credential redemption (and double-spend protection) works.

### Validator internal communication

Tendermint is used within Nym validators to prevent double-spending of generated credentials, and zero-knowledge proof to validate cryptocurrency use cases is built into the system at present. More complex smart contract cases will require the coding of specific zero-knowledge proofs to match the application domain of the contract.

### Validator integrations and use cases

Note the Ethereum integration at the top of the diagram. At present, Nym Validators monitor public blockchains such as Ethereum, since those present a publicly verifiable set of facts which validators can attest to. Bitcoin support will be added soon. But are blockchain applications the only ones?

Not at all.

In principle, a Nym Validator can monitor and sign for any data source it believes it can trust. While cryptocurrency anonymization and blockchain transaction privacy are obvious use cases, there are many other possibilities.

For example, multiple health organisations could co-operate to validate a patient's health record. A patient could then *selectively disclose* aspects of their health record to interested parties, decrypting some parts of it while keeping others hidden. And the whole process could be anonymized through credential re-randomization, so e.g. different health insurance companies would be unable to monitor and identify a patient when they present their health record (assuming that their name or some rare medical condition is not present).

Coconut is a general-purpose technology, useful for ensuring transaction privacy in both blockchain and non-blockchain applications.


# Building and running a Nym Validator node

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

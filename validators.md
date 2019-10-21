---
# Page settings
layout: default
keywords:
comments: false

# Hero section
title: Validators
description: Transaction-level privacy

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

In addition to the normal `sign(message, secretKey)` and `verify(message, publicKey)` functions present in other signature schemes, Coconut adds the following:

1) *[Blind signatures](https://en.wikipedia.org/wiki/Blind_signature)* - disguises message content so that the signer can't see what they're signing. Uses zero-knowledge proofs so that the signer can sign confidently without seeing the unblinded content of the message. This defends users against signers: the entity that signed can't identify the user who created a given credential, since they've never seen the credential when it's unblinded.

2) *Re-randomizable signatures* - take one signature, and generate a brand new signature that is valid for the same underlying message. The new bitstring in the re-randomized signature is equivalent to the original signature but not linkable to it. A user can "show" a credential multiple times, and each time it appears to be a new credential, which is unlinkable to any previous "show". But the underlying content of the re-randomized credential is the same (including for things like double-spend protection).

3) *Selective disclosure of attributes* - allows someone with the public key to verify some, but not all, parts of a message. So you could for instance selectively reveal parts of a signed message to some people, but not to others. This is a very powerful property of Coconut, potentially leading to diverse applications: anonymous voting systems, selective revelation of medical data, etc.

4) *[Threshold issuance](https://en.wikipedia.org/wiki/Threshold_cryptosystem)* - allows signature generation to be split up across multiple nodes and decentralised, so that either all signers need to sign (*n of n* where *n* is the number of signers) or only a threshold number of signers need to sign a message (*t of n* where *t* is the threshold value).

Taken together, these properties provide near-perfect privacy for Nym users when it comes to generating and using signatures for cryptographic claims such as credentials.

### How do Nym Validators work?

If you are a coder and interested in trying it, you can download, build, and run Nym Validator code today. We are also running a small testnet. Here's what the Nym Validators part of our testnet looks like right now:

![validators](../assets/validators.png)

Here's the general flow.

A client (in purple at the bottom) has a message `m` in hand. The message contains a cryptographic claim. The client *blinds* the message (to protect the privacy of message content), so now it's got `Blinded(m)`. It then connects to Nym Validators, presents `Blinded(m)`, and ask for a set of signed threshold credentials.

Validators work together to verify messages, communicating through [Tendermint's](https://tendermint.com/) consensus protocol.

If the blinded message `Blinded(m)` is valid, each validator issues a partial credential. Assuming the signature threshold is met, the client then assembles all of the partial credentials into a single credential `Signed(m)`. From a privacy perspective, this is pretty good: all Nym Validators would need to collude in order to de-anonymize the user. And the validators have never seen the actual message `m` they've signed, so that's private too.

But it's not perfect, insofar as it's hard but not impossible for validators to collude. So the client can now call `randomize(Cm)`. This converts `Signed(m)` into a brand-new credential `Signed(m)'`. The magic part: the underlying message `m` in both `Signed(m)` and `Signed(m)'` can both still be verified independently of which credential it's in. `m` is always `m`, even if it's contained in a new, re-randomized signature.

Re-randomization is cryptographically inexpensive, so you can happily re-randomize every time you want to show the credential. This makes it impossible for anyone to identify a user by tracing where they've previously generated or used a specific credential. Calling `randomize(Signed(m))` before you show a credential makes each show unlinkable to all previous shows.

At this point, the client has `Signed(m)`, which is essentially a privacy-enhanced bearer token signed by the Nym Validators. The meaning of this depends on the content of `m`. It might say *I'm able to pay 2 BTC.* It might say *I haven't voted in the election yet, here's my vote.* Or it might say *I'm over the age of 18, let me into the pub.*

The re-randomized credential can then be passed to Service Providers (SPs). SPs are entities external to Nym, which are able to accept signed Nym Credentials and present them to Nym Validators. The Nym Validators will then take appropriate action based on the nature of the presented credential.

So much for the general flow. Now to the specifics of what's running now.

In the current Nym Validators testnet, we focus primarily on making blockchain transactions private. To demonstrate the technology, we've set up a Nym ERC20 coin running on the Ethereum Ropsten testnet.

The Nym client sends a Nym ERC20 coin to a specific Ethereum address. This locks up the ERC20 coin until it's released by action of the Nym Validators.

The client then goes through the credential assembly dance. It creates a cryptographic claim asserting that it transferred some Nym ERC20 tokens into Nym, and sends it to the validators to sign.

Right now, Service Providers are just dummy SPs which demonstrate that credential spending (and double-spend protection) works.


### Validator internal communication

Tendermint is used within Nym validators to prevent double-spending of generated credentials, and zero-knowledge proof to validate cryptocurrency use cases is built into the system at present.

### Validator integrations and use cases

Note the Ethereum integration at the top of the diagram. At present, Nym Validators monitor public blockchains such as Ethereum, since those present a publicly verifiable set of facts which validators can attest to. Bitcoin support will be added soon. But are blockchain applications the only ones?

Not at all.

In principle, a Nym Validator can monitor and sign for any data source it believes it can trust. While cryptocurrency anonymization and blockchain transaction privacy are obvious use cases, there are many other possibilities.

For example, multiple health organisations could co-operate to validate a patient's health record. A patient could then *selectively disclose* aspects of their health record to interested parties, decrypting some parts of it while keeping others hidden. And the whole process could be anonymized through credential re-randomization, so e.g. different health insurance companies would be unable to monitor and identify a patient when they present their health record (assuming that their name or some rare medical condition is not present).

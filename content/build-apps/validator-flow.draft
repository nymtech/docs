---
title: "Validator flow"
weight: 50
description: "General interaction flow between Nym validators and other network actors."
---

### How do Nym Validators work?

If you are a coder and interested in trying it, you can download, build, and run Nym Validator code today. We are also running a small and somewhat creaky testnet publicly. Nym Validators form a network of decentralized nodes:

![validators](/docs/images/validators.png)

Here's the general flow.

A client (in purple at the bottom) has a message `m` in hand. The message contains a cryptographic claim. The client *blinds* the message (to protect the privacy of message content), so now it's got `Blinded(m)`. It then connects to Nym Validators, presents `Blinded(m)`, and asks for a set of signed threshold credentials.

Validators work together to verify messages, communicating through [Tendermint's](https://tendermint.com/) consensus protocol.

If the blinded message `Blinded(m)` is valid, each validator issues a partial credential. Assuming the signature threshold is met, the client then assembles all of the partial credentials into a single credential `Signed(m)`. From a privacy perspective, this is pretty good: all Nym Validators would need to collude in order to de-anonymize the user. And the validators have never seen the actual message `m` they've signed, so that's private too.

But it's not perfect, insofar as it's hard but not impossible for validators to collude. So the client can now call `randomize(Cm)`. This converts `Signed(m)` into a brand-new credential `Signed(m)'`. The magic part: the underlying message `m` in both `Signed(m)` and `Signed(m)'` can both still be verified independently of which credential it's in. `m` is always `m`, even if it's contained in a new, re-randomized signature. This means that in the context of crypto-currency transaction privacy, double-spend protection works.

Re-randomization is cryptographically inexpensive, so you can happily re-randomize every time you want to show the credential. This makes it impossible for anyone to identify a user by tracing where they've previously generated or used a specific credential. Calling `randomize(Signed(m))` before you show a credential makes each show unlinkable to all previous shows.

At this point, the client has `Signed(m)'`, which is essentially a privacy-enhanced bearer token signed by the Nym Validators. The meaning of this depends on the content of `m`. It might say *I'm able to pay 2 BTC.* It might say *I haven't voted in the election yet, here's my vote.* Or it might say *I'm over the age of 18, let me into the pub.*

The re-randomized credential can then be passed to Service Providers (SPs). SPs are entities external to Nym, which are able to accept signed Nym Credentials and present them to Nym Validators. The Nym Validators will then take appropriate action based on the nature of the presented credential.

### Validator integrations and use cases

Note the Ethereum integration at the top of the diagram. At present, Nym Validators monitor public blockchains such as Ethereum, since those present a publicly verifiable set of facts which validators can attest to. Bitcoin support will be added soon. But are blockchain applications the only ones?

Not at all.

In principle, a Nym Validator can monitor and sign for any data source it believes it can trust. While cryptocurrency anonymization and blockchain transaction privacy are obvious use cases, there are many other possibilities.

For example, multiple health organisations could co-operate to validate a patient's health record. A patient could then *selectively disclose* aspects of their health record to interested parties, decrypting some parts of it while keeping others hidden. And the whole process could be anonymized through credential re-randomization, so e.g. different health insurance companies would be unable to monitor and identify a patient when they present their health record (assuming that their name or some rare medical condition is not present).

Coconut is a general-purpose technology, useful for ensuring transaction privacy in both blockchain and non-blockchain applications.


So much for the general flow. Now to the specifics of what's running now.

---
title: Transaction Privacy
weight: 30
description: "Nym ensures network privacy using layer encrypted Sphinx packets and a Loopix mixnet."
---

### Introducing Coconut

Coconut is a signature scheme that provides transaction privacy. In the context of a blockchain system, this happens by transferring a coin to an address, then creating a privacy-enhanced Coconut credential which provably represents the transferred amount. The credential can then be "spent" anonymously, as if it were the original value. Double-spending protections apply to the credential, so it can only be spent once. Nym Validators can then unlock the value so it can be redeemed by the party holding the anonymized credential.

Although there's still work to be done to integrate it against various blockchains, in principle Coconut can anonymise blockchain transactions in any system which provides multi-sig. Bitcoin and Ethereum are obvious first targets here. We're also looking into [Cosmos](https://cosmos.network) integration at the moment.

Coconut is very flexible, and can ensure privacy for more than coin transfers; it can provide privacy for more complex smart contracts as well. Finally, it should be mentioned that Coconut can be applied to both blockchain and non-blockchain systems - it's a general purpose technology.

### How does Coconut work?

Just like normal credentials, Nym's Coconut credentials can be signed with a secret key and later verified by anybody with the correct public key. But Nym credentials have additional superpowers when compared to "normal" signature schemes like RSA or DSA.

Specifically, Coconut is a blinded, re-randomizable, selective disclosure threshold credential signature scheme. That's quite a mouthful, so let's break it down into its component parts.

Let's say you have a message (`hello world`) in hand. In addition to the normal `sign(message, secretKey)` and `verify(message, publicKey)` functions present in other signature schemes, Coconut adds the following:

1) *[Blind signatures](https://en.wikipedia.org/wiki/Blind_signature)* - disguises message content so that the signer can't see what they're signing. This defends users against signers: the entity that signed can't identify the user who created a given credential, since they've never seen the message they're signing before it's been *blinded* (turned into gobbledygook). Coconut uses zero-knowledge proofs so that the signer can sign confidently without seeing the unblinded content of the message.

2) *Re-randomizable signatures* - take a signature, and generate a brand new signature that is valid for the same underlying message `hello world`. The new bitstring in the re-randomized signature is equivalent to the original signature but not linkable to it. So a user can "show" a credential multiple times, and each time it appears to be a new credential, which is unlinkable to any previous "show". But the underlying content of the re-randomized credential is the same (including for things like double-spend protection). This once again protects the user against the signer, because the signer can't trace the signed message that they gave back to the user when it is presented. It also protects the user against the relying party that accepts the signed credential. The user can show re-randomized credentials repeatedly, and although the underlying message is the same in all cases, there's no way of tracking them by watching the user present the same credential multiple times.

3) *Selective disclosure of attributes* - allows someone with the public key to verify some, but not all, parts of a message. So you could for instance selectively reveal parts of a signed message to some people, but not to others. This is a very powerful property of Coconut, potentially leading to diverse applications: anonymous voting systems, selective revelation of medical data, etc.

4) *[Threshold issuance](https://en.wikipedia.org/wiki/Threshold_cryptosystem)* - allows signature generation to be split up across multiple nodes and decentralised, so that either all signers need to sign (*n of n* where *n* is the number of signers) or only a threshold number of signers need to sign a message (*t of n* where *t* is the threshold value).

Taken together, these properties provide excellent privacy for Nym users when it comes to generating and using signatures for cryptographic claims.

A slightly expanded view of Coconut is available [in this blog post](https://medium.com/nymtech/nyms-coconut-credentials-an-overview-4aa4e922cd51).
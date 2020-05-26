---
title: Transaction privacy
weight: 30
description: "Nym ensures network privacy using layer encrypted Sphinx packets and a Loopix mixnet."
---

Coconut is a signature scheme that provides transaction privacy. In the context of a blockchain system, this happens by transferring a coin to an address, then creating a privacy-enhanced Coconut credential which provably represents the transferred amount. The credential can then be "spent" anonymously, as if it were the original value. Double-spending protections apply to the credential, so it can only be spent once. Nym Validators can then unlock the value so it can be redeemed by the party holding the anonymized credential.

Although there's still work to be done to integrate it against various blockchains, in principle Coconut can anonymise blockchain transactions in any system which provides multi-sig. Bitcoin and Ethereum are obvious first targets here. We're also looking into [Cosmos](https://cosmos.network) integration at the moment.

Coconut is very flexible, and can ensure privacy for more than coin transfers; it can provide privacy for more complex smart contracts as well. Finally, it should be mentioned that Coconut can be applied to both blockchain and non-blockchain systems - it's a general purpose technology.

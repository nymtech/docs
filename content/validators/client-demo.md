---
title: "Client Demo"
weight: 60
description: "Client applications interact with Nym Validator nodes through a piece of client software. In order to demonstrate the general flow detailed above, we've embedded the client in a QT-based GUI application to show how it works."
---

{{% notice warning %}}
We are in the process of rebuilding our validators in Rust. While these instructions are still correct, it is a lot of work to set up a Nym validator in our old Go codebase. We are working to make the process a lot simpler.  If you're tempted to run a validator, you should **strongly consider waiting** for our next release, v0.7.0, and run our new validator code.
{{% /notice %}}


## Nym Validator Testnet

In the current Nym Validators testnet, we focus primarily on making blockchain transactions private. To demonstrate the technology, we've set up a Nym ERC20 coin running on the Ethereum Ropsten testnet.

The Nym client sends a Nym ERC20 coin to a specific Ethereum address. This locks up the ERC20 coin until it's released by action of the Nym Validators.

The client then goes through the credential assembly dance. It creates a cryptographic claim asserting that it transferred Nym ERC20 token(s) into Nym, and sends it to the validators to sign. Validators monitor the Ethereum blockchain, watching for Nym coin transactions, so they're able to verify what happened, and decide whether the client has in fact transferred value, and whether the client has overspent (in which case the credential creation request will be denied).

Right now, Service Providers are just dummy SPs which demonstrate that credential redemption (and double-spend protection) works.


### Client Demo

Client applications interact with Nym Validator nodes through a piece of client software. In order to demonstrate the general flow detailed above, we've embedded the client in a QT-based GUI application to show how it works.

We've packaged it for Linux, Mac OS X, and Windows. You can download it from the releases page:

https://github.com/nymtech/qt-validator-client-demo/releases/tag/v0.0.1

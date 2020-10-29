---
title: Run a crypto wallet
weight: 35
description: "You can protect your cryptocurrency transactions from network eavesdroppers using the Nym mixnet. Here's how."
---

{{% notice info %}}
The Nym SOCKS5 Client was built in the [quickstart](/docs/quickstart) section. If you haven't yet built Nym and want to run the code on this page, go there first.
{{% /notice %}}

Nym is a general purpose system. We aim to provide the strongest possible protections for internet traffic and transactions.

The system is still very young, but it's starting to be able to do useful work. You can try it today, by protecting your cryptocurrency wallet network traffic.

Many existing wallets are able to use the SOCKS5 proxy protocol. Let's see how we can set up a crypto wallet to send its traffic through the Nym mixnet using [Electrum](https://electrum.org/) or [Blockstream Green](https://blockstream.com/green/), our first two supported wallets. 

## Running the Nym socks5 proxy

After building the Nym platform code, initialize the SOCKS5 proxy:

`./target/release/nym-socks5-client init --id nym-testnet-sphinx-socks --provider C7cown6dYCLZpLiMFC1PaBmhvLvmJmLDJGeRTbPD45bX.CRNfBGFApq1pobU72fUwym6RCucdaudJ2H2rPWJqPPAB@D6YaMzLSY7mANtSQRKXsmMZpqgqiVkeiagKM4V4oFPFr --gateway D6YaMzLSY7mANtSQRKXsmMZpqgqiVkeiagKM4V4oFPFr`. 

The `--provider` field needs to be filled with the Nym address of a SphinxSocks provider that can make network requests on your behalf. The one above is the inital Nym one, but you can run your own if you want.

Then run the socks5 proxy locally:

`./target/release/nym-socks5-client run --id nym-testnet-sphinx-socks`

This will start up a SOCKS5 proxy on your local machine, at `localhost:1080`. Now you can point a wallet at it. Here's how.


## Blockstream Green example

Set your proxy settings in Green as follows. First you need to log out, the click on the settings on the right hand side to set proxy URL:

![Blockstream Green settings](/docs/images/wallet-proxy-settings/blockstream-green.gif)


Most wallets and other applications will work basically the same way: find the network proxy settings, enter the proxy url (host: localhost, port: 1080). 

Here's how it looks in Electrum:

![Electrum settings](/docs/images/wallet-proxy-settings/electrum.gif)

Once you start using the proxy, your wallet traffic will be sliced up into Sphinx packets, bounced and shuffled as wallet requests and responses pass through the Nym mixnet.

## Other wallets

At the moment, we are only supporting Green and Electrum requests through the SphinxSocks proxy, because we don't want to run an open proxy which can easily be abused. 

We will be adding support for additional wallets very quickly over the coming days and weeks. If you want to help us do that, follow the [SphinxSocks quickstart](/docs/quickstart/sphinx-socks).

## KeyBase

We have just added experimental support for KeyBase (which we use for our own internal chat). Feel free to try that out and say hello!
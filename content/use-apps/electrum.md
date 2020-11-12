---
title: Electrum
weight: 35
description: "You can protect your Electrum transactions from network eavesdroppers using the Nym mixnet. Here's how."
---

{{% notice info %}}
You need to [run the Nym Socks5 client](/docs/use-apps/) before following the instructions on this page.
{{% /notice %}}

Here's how you use Electrum with Nym's Socks5 client:

![Electrum settings](/docs/images/wallet-proxy-settings/electrum.gif)

Once you start using the nym-socks5-client, your wallet traffic will be sliced up into Sphinx packets, bounced and shuffled as wallet requests and responses pass through the Nym mixnet.
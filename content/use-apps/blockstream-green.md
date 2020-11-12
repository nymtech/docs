---
title: Blockstream Green
weight: 35
description: "You can protect your Blockstream Green transactions from network eavesdroppers using the Nym mixnet. Here's how."
---

{{% notice info %}}
You need to [run the Nym Socks5 client](/docs/use-apps/) before following the instructions on this page.
{{% /notice %}}


[Blockstream Green](https://blockstream.com/green/) is a BitCoin and Liquid wallet. Since it supports Socks5, it can use Nym. Set your proxy settings in Green as follows. 

First you need to log out.

Next, click on the settings on the right hand side to set proxy URL:

![Blockstream Green settings](/docs/images/wallet-proxy-settings/blockstream-green.gif)


Most wallets and other applications will work basically the same way: find the network proxy settings, enter the proxy url (host: **localhost**, port: **1080**). 

In some other applications, this might be written as **localhost:1080** if there's only one proxy entry field. 


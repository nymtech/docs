---
title: Use Apps
weight: 60
description: "Tutorials for building Privacy Enhanced Applications (or integrating existing apps with Nym)"
---

{{% notice info %}}
The Nym SOCKS5 Client was built in the [building nym](/docs/run-nym-nodes/build-nym/) section. If you haven't yet built Nym and want to run the code on this page, go there first.
{{% /notice %}}

Nym is a general purpose system. We aim to provide the strongest possible protections for internet traffic and transactions.

The system is still very young, but it's starting to be able to do useful work. You can start using it today.

Many existing applications are able to use the SOCKS5 proxy protocol. They can use the `nym-socks5-client` to bounce their network traffic through the Nym network, like this: 

![Socks5 architecture](/docs/images/nym-socks5-architecture.png)

The Nym network already runs the mixnet, and the `nym-network-requester` / `nym-client` parts. In order to use existing applications with Nym, you only need to set up the `nym-socks5-client`. 

Note that the nym-network-requester we're running works only for specific applications. We are not running an open proxy, we have an allowed list of applications that can use the mixnet (currently Blockstream Green, Electrum, and KeyBase). We can add other applications upon request, just come talk to us in our dev chat. Or, you can [set up your own](/docs/run-nym-nodes/requester) `nym-network-requester`, it's not very hard to do if you have access to a server.

## Running the nym-socks5-client

{{% notice warning %}}
**Obligatory disclaimer time:** The Nym mixnet is still under construction and has not undergone a security audit. Do not rely on it for strong privacy (yet).
{{% /notice %}}

After building the Nym platform code, initialize `nym-socks5-client`:

`nym-socks5-client init --id my-socks5-client --provider C7cown6dYCLZpLiMFC1PaBmhvLvmJmLDJGeRTbPD45bX.CRNfBGFApq1pobU72fUwym6RCucdaudJ2H2rPWJqPPAB@DiYR9o8KgeQ81woKPYVAu4LNaAEg8SWkiufDCahNnPov`. 

The `--provider` field needs to be filled with the Nym address of a `nym-network-requester` that can make network requests on your behalf. The one above is the initial Nym one, but you can [run your own](/docs/run-nym-nodes/requester/) if you want.

Then run the socks5 client locally:

`nym-socks5-client run --id my-socks5-client`

This will start up a SOCKS5 proxy on your local machine, at `localhost:1080`. 

In the next few sections, we will show you how to run it with some existing applications. Later, we will discuss how you can use any application that can use SOCKS5 with Nym.
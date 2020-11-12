---
title: Requesters
weight: 37
description: "Run a requester proxy for the benefit of the community."
---

{{% notice info %}}
The `nym-network-requester` was built in the [building nym](/docs/build-nym) section. If you haven't yet built Nym and want to run the code on this page, go there first.
{{% /notice %}}

If you have access to a server, you can run the nym-network-requester, which allows Nym users to make outbound network requests from your server. 

The nym-network-requester is NOT an open proxy. It ships with a file called `allowed.list.sample`, which contains URLs used by the Blockstream Green and Electrum cryptographic wallets. 

## Running nym-network-requester

You can run the requester yourself, by taking the following steps. 

On your server, build Nym. Then run the following commands from the top-level `nym` directory:

1. `target/release/nym-client init --gateway D6YaMzLSY7mANtSQRKXsmMZpqgqiVkeiagKM4V4oFPFr --id nym-network-requester-client`
2. `target/release/nym-client run --id nym-network-requester-client`
3. `target/release/nym-network-requester run`

This will start up a Nym client, and the nym-network-requester requester will attach to it. 

Make a note of the address of the client when it starts up:

```
 2020-09-10T14:45:50.131 INFO  nym_client::client              > The address of this client is: EzvzfN4baf3ULUbAmExQELUWMQry7qqVDibSyekR31KE.4khUuTUyYTWiLki3SKbxeG2sP3mwgn9ykBhvtyaLfMdN@D6YaMzLSY7mANtSQRKXsmMZpqgqiVkeiagKM4V4oFPFr
```

Copy the whole address (format `xxx.yyy@zzz`) and keep it somewhere. You can use it yourself, give it to friends, or (if you would like to run a nym-network-requester for the whole Nym network) give it to us and we can put it in the Nym documentation.

Is this safe to do? If it was an open proxy, this would be unsafe, because any Nym user could make network requests to any system on the internet.

To make things a bit less stressful for administrators, nym-network-requester drops all incoming requests by default. In order for it to make requests, you need to add specific domains to the `allowed.list` file at `$HOME/.nym/service-providers/nym-network-requester/allowed.list`.

If you want, you can just use the domains in the default `allowed.list`, by running this command from the top-level `nym` code directory:

`cp service-providers/nym-network-requester/allowed.list.sample ~/.nym/service-providers/nym-network-requester/allowed.list`

Those URLs will let through requests for the Blockstream Green and Electrum cryptocurrency wallets.

**IMPORTANT: If you changed your allowed.list, make sure you restart nym-network-requester to pick up the new allowed request list.**

## Adding URLs for other clients

It would suck if Nym was restricted to only two clients. How can we add support for a new application? It's fairly easy to do. 

Have a look in your nym-network-requester config directory:

```
ls $HOME/.nym/service-providers/sphinx-socks/

# returns: allowed.list  unknown.list
```

We already know that `allowed.list` is what lets requests go through. All unknown requests are logged to `unknown.list`. If you want to try using a new client type, just start the new application, point it at your local SOCKS5 proxy (configured to use your remote nym-network-requester), and keep copying URLs from `unknown.list` into `allowed.list` (it may take multiple tries until you get all of them, depending on the complexity of the application). 

If you add support for a new application, we'd love to hear about it: let us know or submit a commented pull request on `allowed.list.sample`

## Running an open proxy

If you really, really want to run an open proxy, perhaps for testing purposes for your own use or among a small group of trusted friends, it is possible to do so. You can disable network checks by passing the flag `--open-proxy` flag when you run it. If you run in this configuration, you do so at your own risk. 
---
title: SphinxSocks
weight: 37
description: "Run a SOCKS5 proxy requester for the benefit of the community."
---

{{% notice info %}}
SphinxSocks was built in the [quickstart](/docs/quickstart) section. If you haven't yet built Nym and want to run the code on this page, go there first.
{{% /notice %}}

If you have access to a server, you can run the SphinxSocks proxy requester, which allows Nym users to make outbound network requests from your server. 

SphinxSocks is NOT an open proxy. It ships with a file called `allowed.list.sample`, which contains URLs used by the Blockstream Green and Electrum cryptographic wallets. 

## Running SphinxSocks

You can run the proxy yourself, by taking the following steps. 

On your server, compile Nym. Then run the following commands from the top-level `nym` directory:

1. `target/release/nym-client init --gateway D6YaMzLSY7mANtSQRKXsmMZpqgqiVkeiagKM4V4oFPFr --id sphinxsocks-client`
2. `target/release/nym-client run --id sphinxsocks-client`
3. `target/release/sphinx-socks run`

This will start up a Nym client, and the SphinxSocks requester will attach to it. 

Make a note of the address of the client when it starts up:

```
 2020-09-10T14:45:50.131 INFO  nym_client::client              > The address of this client is: EzvzfN4baf3ULUbAmExQELUWMQry7qqVDibSyekR31KE.4khUuTUyYTWiLki3SKbxeG2sP3mwgn9ykBhvtyaLfMdN@D6YaMzLSY7mANtSQRKXsmMZpqgqiVkeiagKM4V4oFPFr
```

Copy the whole address (format `xxx.yyy@zzz`) and keep it somewhere. You can use it yourself, give it to friends, or (if you would like to run a SphinxSocks requester for the whole Nym network) give it to us and we can put it in the Nym documentation.

Is this safe to do? If it was an open proxy, you could be opening yourself up for some trouble, because presumably any (anonymous) Nym user could make network requests to any system on the internet.

To make things a bit less stressful for adminsitrators, SphinxSocks will drop all incoming requests by default. In order for it to make requests, you need to add specific domains to the `allowed.list` file at `$HOME/.nym/service-providers/sphinx-socks/allowed.list`.

If you want, you can just use the domains in the default `allowed.list`, by running this command from the top-level `nym` code directory:

`cp service-providers/sphinx-socks/allowed.list.sample ~/.nym/service-providers/sphinx-socks/allowed.list`

Those URLs will let through requests for the Blockstream Green and Electrum cryptocurrency wallets.

**IMPORTANT: If you changed your allowed.list, make sure you restart SphinxSocks to pick up the new allowed request list.**

## Adding URLs for other clients

It would suck if Nym was restricted to only two clients. How can we add support for a new application? It's fairly easy to do. 

Have a look in your SphinxSocks config directory:

```
ls $HOME/.nym/service-providers/sphinx-socks/

# returns: allowed.list  unknown.list
```

We already know that `allowed.list` is what lets requests go through. All unknown requests are logged to `unknown.list`. If you want to try using a new client type, just start the new application, point it at your local SOCKS5 proxy (configured to use your remote SphinxSocks requester), and keep copying URLs from `unknown.list` into `allowed.list` (it may take multiple tries until you get all of them, depending on the complexity of the application). 

If you add support for a new application, we'd love to hear about it: let us know or submit a commented pull request on `allowed.list.sample`
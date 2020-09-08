---
title: "Webassembly client"
weight: 45
description: "How to integrate the Nym webassembly client into your own applications to enable strong privacy for your users"
---

The Nym webassembly client allows any webassembly-capable runtime to build and send Sphinx packets to the Nym network. 


{{% notice warning %}}
The WebAssembly client is **currently being worked on** - it is not yet compatible with v0.8.0 of the Nym platform. We will have it ready very soon, as a point release (**v0.8.1**).
{{% /notice %}}


You can install [@nymproject/nym-client-wasm](https://www.npmjs.com/package/@nymproject/nym-client-wasm) from NPM from its package page, or 

```
npm i @nymproject/nym-client-wasm
``` 

The `nym-client-wasm` package allows easy creation of Sphinx packets from within mobile apps and browser-based client-side apps (including Electron or similar). Browser extensions should also work.

As the [quickstart example](/docs/quickstart/send-some-packets) shows, it's possible to deliver web apps that build and send Sphinx packets in a solely in a web browser window. However, note that all the normal constraints of [browser-based key storage](https://pomcor.com/2017/06/02/keys-in-browser/) and same-origin rules (which are there for good reason) make it difficult to structure pure webapps apps securely. We are still assessing what can be done here, if anything.

## Building peaps with nym-client-wasm

We've already looked that the basics of peap creation via the webassembly client in the [quickstart](/docs/quickstart/send-some-packets). 

### Initializing a new Nym identity

The main methods you'll use from the NPM package are: 

```js
let identity = new Identity();
```

This generates a new Nym identity, consisting of a public/private keypair and a Nym gateway address.


### Constructing a Nym client

```js
let client = new Client(directoryUrl, identity, authToken);
```

This returns a nym Client which connects to a Nym gateway via websocket. All communication with the Nym network happens through this client.

The `directoryUrl` of the Nym testnet is `https://directory.nymtech.net`. Use that if you want to connect to the running testnet. 

If you are [running a local network](/docs/build-peapps/running-localnet), use `http://127.0.0.1:8080` as your `directoryUrl`.

### Running the Nym client

```js
client.start();
```

This will cause the client to retrieve a network topology from the defined `directoryUrl`, and connect to its gateway via websocket. Cover traffic is not yet sent, but message sends should work after client start. 

### Sending messages

```js
client.sendMessage(message, recipient) {
```

Sends a message up the websocket to this client's Nym gateway.
 
NOTE: the webassembly client currently does not implement chunking. Messages over ~1KB will cause a panic. This will be fixed in a future version.
 
`message` must be a string at the moment. Binary `Blob` and `ArrayBuffer`
will be supported soon. 

`recipient` is a Nym address as a string.


### Getting the client's address

Given a client, to get its address, you can call:

```js
client.formatAsRecipient();
```

### SURBs

Anonymous replies using surbs don't yet work in the webassembly client. They should be available in the next release (0.8.0).

### JSON

Sending JSON is fairly simple. If you're playing with the quickstart wasm example app, just stick it into the message box and send it (or send it programmatically as the `message` content of `client.sendMessage(message, recipient)` in your own application code.

### Think about what you're sending!

{{% notice warning %}}
Think about what information your app sends. That goes for whatever you put into your Sphinx packet messages as well as what your app's environment may leak.
{{% /notice %}}

Whenever you write client peaps using HTML/JavaScript, we recommend that you do not load external resources from CDNs. Webapp developers do this all the time, to save load time for common resources, or just for convenience. But when you're writing privacy apps it's better not to make these kinds of requests. Pack everything locally.

If you use only local resources within your Electron app or your browser extensions, explicitly encoding request data in a Sphinx packet does protect you from the normal leakage that gets sent in a browser HTTP request. [There's a lot of stuff that leaks when you make an HTTP request from a browser window](https://panopticlick.eff.org/). Luckily, all that metadata and request leakage doesn't happen in Nym, because you're choosing very explicitly what to encode into Sphinx packets, instead of sending a whole browser environment by default.
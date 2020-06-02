---
title: Send messages
weight: 40
description: "Build your first Nym privacy enhanced application, a simple chat application that works in the browser"
---

Before we start, the obligatory immature cryptography warning.

{{% notice warning %}}
Please, don't depend on our code for strong privacy (yet). We are still at an early stage.{{% /notice %}}

Having said that, we are aiming to bring very strong privacy guarantees to users and service providers, and you want to see how it works. So let's dance. 

This quickstart demonstrates how you can use Nym from webassembly-capable browser or mobile apps. Other languages are supported via a Rust client which exposes a websocket to give you the same functionality as what we explain here - so if you want to write a Nym app in any server-side language (Python, JavaScript, C#, Java, Scala, etc) you can do that. See the [Build Privacy Applications](/docs/build-peapps) section of the docs for more information.


## Setup

Install [npm](https://www.npmjs.com/get-npm) for your platform. Then, from the top-level `nym` directory:

```
cd clients/webassembly/js-example
npm install
npm run start
```

This will install the [Nym webassembly client](https://www.npmjs.com/package/@nymproject/nym-client-wasm) and start a local webserver on [http://localhost:8001](http://localhost:8001). 

It's a simple chat interface, allowing you to enter a recipient address and send a message. We'll try it out in a moment, but before we do, it makes sense to talk about addressing, and the concept of Nym identities, so you can understand what an address is.

## Nym identities

Nym identities are denoted a bit like email addresses. But instead of being **user@host**, a Nym identity is **user-public-key@gateway-public-key**.

When the demo code loads, a new Nym identity is constructed, and its public key is put into the text field labelled *Sender*. This identity is regenerated each page load to keep the demo as simple as possible - it'll look something like:

**71od3ZAupdCdxeFNg8sdonqfZTnZZy1E86WYKEjxD4kj@FWYoUrnKuXryysptnCZgUYRTauHq4FnEFu2QGn5LZWbm**

Note that there's an `@` in the middle. Your address will be different, but it will have the same format.

In my example, everything before the `@`, i.e. **71od3ZAupdCdxeFNg8sdonqfZTnZZy1E86WYKEjxD4kj** is the public key of our Nym identity.

Everything after the `@`, i.e. **FWYoUrnKuXryysptnCZgUYRTauHq4FnEFu2QGn5LZWbm** is the public key of a Nym gateway where messages will be received for this identity. 

## Sending mixnet messages using JavaScript and WebAssembly

The simplest demo: send a packet through the mixnet to yourself. Copy the entire contents of the *Sender* field into the *Recipient* field. Then press the *Send* button.

![send a packet](/docs/images/send-a-packet.gif)

The message in the *Message* field is wrapped up in Sphinx layer encryption, mixed with other peoples' traffic, bounced all over our glorious planet, and routed back to your browser window.

To create and send to another identity, open up another browser tab at [http://localhost:8001](http://localhost:8001). Copy the *Sender* from one of your browser windows into the *Recipient* of the other, and you'll be able to send information back and forth.

Now let's look at the code. 

## User interface

The HTML user interface is simple, ugly, and effective (if you have UI skills and want to help a privacy project, please get in touch!). It looks like this:

```html
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Nym WebAssembly Demo</title>
</head>

<body>
  <p>
    <label>Sender: </label><input disabled="true" size="85" type="text" id="sender" value="">
  </p>

  <p>
    <label>Recipient: </label><input size="85" type="text" id="recipient" value="">
  </p>
  <p>
    <label>Message: </label><input type="text" id="message" value="Hello mixnet!">
  </p>
  <p>
    <button id="send-button">Send</button>
  </p>

  <p>Send messages from your browser, through the mixnet, and to the recipient using the "send" button.</p>
  <p><span style='color: blue;'>Sent</span> messages show in blue, <span style='color: green;'>received</span>
    messages show in green.</p>

  <hr>
  <p>
    <span id="output"></div>
  </p>
  <script src="./bootstrap.js"></script>

</body>

</html>
```

Nothing too thrilling here - we define user interface controls with ids `sender`, `recipient`, `message`  and `send-button`, then load our JavaScript.


## JavaScript

We're depending on the `@nymproject/nym-client-wasm` npm package in `package.json`:

```
  "dependencies": {
    "@nymproject/nym-client-wasm": "^0.7.4"
  }
```

Choose the highest SemVer patch version for the Nym network version you're connecting to. E.g. if most Nym nodes in the dashboard are running `0.7.something`, pick the newest `0.7.x` release from the [nym-client-wasm npmjs page](https://www.npmjs.com/package/@nymproject/nym-client-wasm).

In our `index.js`, we import the Nym `Client` and `Identity`:

```javascript
import {
    Client,
    Identity
} from "nym-client-wasm/client"
```

An `Identity` is a cryptographic identity containing a public/private keypair, and a gateway address. 

The `Client` is a network wrapper which talks to a Nym gateway server over a websocket.

Let's see them in action. This is a mixnet client in JavaScript:

```javascript
async function main() {
    // Set up identity and client
    let directory = "https://qa-directory.nymtech.net";
    let identity = new Identity();
    let nymClient = new Client(directory, identity, null);

    // Wire up events callbacks
    nymClient.onConnect = (_) => displaySenderAddress(nymClient);
    nymClient.onText = displayReceived;
    nymClient.onErrorResponse = (event) => alert("Received invalid gateway response", event.data);

    // Start the Nym client. Connects to a Nym gateway via websocket.
    await nymClient.start();

    // Wire up the `send` button
    const sendButton = document.querySelector('#send-button');
    sendButton.onclick = function () {
        sendMessageTo(nymClient);
    }
}
```

It's not complex, but let's take it piece by piece. 

```javascript
let directory = "https://qa-directory.nymtech.net";    // 1
let identity = new Identity();                         // 2
let nymClient = new Client(directory, identity, null); // 3
```

In line 1, the variable `directory` is a URL pointing at a Nym network instance (in this case, our QA network). The Nym directory holds IP address and public key info for Nym mixnodes, validators, and gateways. See the mixnet docs for more on this.

Line 2 creates a new `Identity` object. 

Line 3 initializes a new Nym `Client` using the given directory and identity. The third parameter, `authToken`, is null. 

At this point, we've got a `nymClient` instance. When we tell the client to `start()`, it will connect to the Nym gateway via a websocket. But if we connect right now, we won't see anything in our application. We need to wire the client to our user interface.

Let's configure `nymClient` to connect it to our UI.

When we connect to the Nym gateway, we will want to display the sender address (i.e. our own address) in the *Sender* text field. The callback `onConnect` lets us trigger our own actions. When we receive messages from the mixnet, we want to display them in our user interface. And if we get an error when attempting to connect, we'll use good old fashioned `alert()` to display it.


```js
nymClient.onConnect = (_) => displaySenderAddress(nymClient);
nymClient.onText = displayReceived;
nymClient.onErrorResponse = (event) => alert("Received invalid gateway response", event.data);
```

Clicking the *Send* button should send our message. 

```js
const sendButton = document.querySelector('#send-button');
sendButton.onclick = function () {
    sendMessageTo(nymClient);
}
```

Finally, we can start the client:

```js
await nymClient.start();
```

At this point, a lot of things happen.

1. The `nymClient` talks to the defined `directory` and asks it for a list of currently running gateways, mixnodes, and validators. We call this the network *topology*.
2. Once it has the network topology in hand, `nymClient` connects to the first gateway it finds, via a websocket connection.
3. As noted previously, our `nymClient` was initialized without an authentication token. So it registers an account on the gateway, and gets back an authentication token in response. In a real application, we'd save that authtoken so we could use it to talk to the gateway later. 


Now that `nymClient` is registered, we can send messages over the mixnet.


## Sending a packet

We've already wired our `sendButton.onClick` to the function `sendMessageTo(client)`. Here's what it looks like:


```js
function sendMessageTo(nymClient) {
    var message = document.getElementById("message").value;
    var recipient = document.getElementById("recipient").value;
    nymClient.sendMessage(message, recipient);
    displaySend(message);
}
```

The interesting line here is `nymClient.sendMessage(message, recipient)`. The client takes the `message` and the `recipient` from the user interface and calls `sendMessage`. The Nym client JavaScript talks to a webassembly binary which does layer encryption of a Sphinx packet. The client then sends this encrypted binary blob up the websocket connection to the Nym gateway.

The gateway translates to/from IPv4/IPv6 if necessary, and forwards the Sphinx packet to the mixnet. The packet then traverses the mixnet through multiple *hops*, with one layer of encryption being stripped each time. 

After exiting the mixnet, still encrypted in Sphinx, the packet reaches the destination gateway. If the recipient that the packet is addressed to is currently online, the packet will be delivered immediately. If the recipient is offline, the packet will be stored until the user comes online, and then delivered. 

#### Sphinx packet creation

Clients create Sphinx packets. These packets are a bit complicated, but for now all you need to know is that they have the following characteristics:

1. they consist of a header and a body
1. the header contains unencrypted routing data
1. bodies are encrypted
1. bodies are padded so that they're all the same size
1. observers can't tell anything about what's inside the encrypted body
1. the body is layer-encrypted - it may contain either another sphinx packet or a payload message

### SURBs

Anonymous replies are possible using **S**ingle **U**se **R**eply **B**locks, or SURBs. They don't yet exist in the WebAssembly client, but should be available in the next release.

Why would you want SURBs? It's useful to be able to reply to someone without necessarily knowing who they are. Keep in mind, recipients are not necessarily people: they can be privacy-respecting Service Providers, or people. SURBs allow Service Providers to respond to users without knowing who they are. 

### JSON

Sending JSON is totally possible, just stick it into the message box and send it (or send it programmatically if you're writing an application of your own).


### Further reading

So far, we've just scratched the surface. See the [Build Privacy Applications](/docs/build-peapps) docs for a discussion of anonymous replies, key storage, running mixnodes, writing Service Providers, and using other languages to talk to the mixnet.

{{% notice info %}}
If you run into trouble, please ask for help in the channel **nymtech.friends#general** on [KeyBase](https://keybase.io).
{{% /notice %}}
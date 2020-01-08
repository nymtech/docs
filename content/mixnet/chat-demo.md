---
title: "Chat demos"
weight: 60
---

You can try out our running mixnet today using a demo application.


#### GUI client in Electron

The nym-mixnet [client](../clients) exposes network sockets (specifically websockets or TCP sockets, it's up to you).

To demonstrate the use of a websocket, we've built an [Electron chat demo](https://github.com/nymtech/demo-mixnet-electron-chat) showing how you'd use the network interface via JavaScript and websockets. Usage from other languages will be similar - you can communicate from your own code the Nym mixnet client via socket calls, and receive info back up the socket as well.

This makes it possible to interact with the mixnet from applications written in any language.

![electron client](/docs/images/electron.gif)

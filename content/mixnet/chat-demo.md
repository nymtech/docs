---
title: "Chat demo"
weight: 60
---

You can try out our running mixnet today using two demo applications.

Both of them implement chat functionality. But they do it in different ways.

#### Console client in Golang

The first chat client is a Go-based console app. Build and run it, and you get a chat app in a terminal. It bakes in the nym-mixnet [client](../clients) using the Go compiler and method calls.

If you want to try it, grab the code from the [Go chat demo Github repo](https://github.com/nymtech/demo-mixnet-chat-client) - build and usage instructions are there. Here's a quick GIF of the console client in action:

![chat client](/docs/images/conversation.gif)


#### GUI client in Electron

In languages other than Go, the nym-mixnet [client](../clients) exposes network sockets (specifically websockets or TCP sockets, it's up to you).

To demonstrate the use of this, we've built an [Electron chat demo](https://github.com/nymtech/demo-mixnet-electron-chat) showing how you'd use the network interface via JavaScript and websockets. Usage from other languages will be similar - you can communicate from your own code the Nym mixnet client via socket calls, and receive info back up the socket as well.

This makes it possible to interact with the mixnet from applications written in any language.

![electron client](/docs/images/electron.gif)

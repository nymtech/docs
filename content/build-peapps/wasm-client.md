---
title: "Nym client (webassembly)"
weight: 50
description: "How to integrate the Nym webassembly client into your own applications to enable strong privacy for your users"
---

TODO intro

Note that you'll want to ensure no resource leakage when you load external resources, or you may totally defeat the whole point of the anonymity you're getting from the mixnet. 

Setting up request data in a Sphinx packet does protect you from all the leakage that gets sent in a browser HTTP request: unlike a Tor browser integration, you need to explicitly . This is a big advantage: as an application developer you're only sending info that you determine secure to send (whitelist), rather than sending a whole browser environment by default, including all the browser metadata, css, javascript, and image asset requests from non-secure third party servers. 

When designing your Peaps, think hard about this sort of resource leakage. Think hard about your security model, and make sure you don't accidentally send anything that could publicly identify a user!

The use of Sphinx in browser tech is basically for (a) mobile apps and (b) client-side apps (e.g. Electron or similar). Things like browser extensions should also work fine, although we haven't tried to build one yet.

While it's possible to deliver straight-up web apps that build and send Sphinx packets in a browser window, all the normal constraints of [browser-based key storage](https://pomcor.com/2017/06/02/keys-in-browser/) and same-origin rules (which are there for good reason) make it difficult to structure these apps securely. We are still assessing what can be done here, if anything.

### SURBs

Anonymous replies are possible using **S**ingle **U**se **R**eply **B**locks, or SURBs. They don't yet exist in the WebAssembly client, but should be available in the next release (0.8.0).

Why would you want SURBs? Keep in mind that Peap recipients are not necessarily people: they can be privacy-respecting Service Providers, or users. SURBs allow Service Providers to respond to users without knowing who they are. 

### JSON

Sending JSON is fairly simple. If you're looking at the Quickstart wasm example app, just stick it into the message box and send it (or send it progammatically if you're writing an application of your own).

{{% notice warning %}}
Security note about resource leakage when building apps would be good!
{{% /notice %}}

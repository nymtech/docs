---
title: "Directory"
weight: 40
description : "The Nym directory handles presence and public key information so that network participants can find each other."
---

Note that in the preceding discussions of Nym Validators and Nym Mixnodes, quite a bit is assumed. How does a mixnet client know which nodes exist, and what their IP addresses are? How does it find out their public keys so it can encrypt messages to them, and verify that responses came from them? How can the dashboard measure overall mixnet throughput?

The [Nym Directory](https://github.com/nymtech/nym-directory) handles all of these concerns:

* presence - each Nym node sends a heartbeat message to the Directory every few seconds so clients know what's running
* public key infrastructure (PKI) - each node sends its public key as an identifier with the presence messages
* metrics - if desired, Nym Mixnodes can optionally send information about packets sent/received to the Nym Directory, so we can monitor performance in the testnet. If you would like to implement any Nym Mixnet visualizations, there's a websocket available for metrics at `wss://directory.nymtech.net/ws`. If you would like to see its output in a browser, go to https://directory.nymtech.net/.

The Nym Directory exposes a simple REST API. Swagger docs are at [https://directory.nymtech.net/swagger/index.html](https://directory.nymtech.net/swagger/index.html)

The Nym Directory is currently centralised. This is not desirable as it's a single point of failure (or attack) for the system as a whole.

While we're still in early testnet mode, the Nym Directory works well enough to bootstrap the testnet into existence. Once our mixnet Quality of Service system, and Proof of Stake system, they'll take over the functionality of the Directory.

A very simple version of staking and directory services is currently planned for our next release (v0.8.0). The Nym Directory will then be pared back so that it only shows network metrics. 

#### Installation (for developers)

If you're building applications using Nym technology, it can often be useful to run your own directory server on your development machine.

Install Go 1.12 or later, and then do:

```shell
git clone https://github.com/nymtech/nym-directory.git
cd nym-directory
git checkout tags/v0.5.0
go run main.go
```

That should start up the directory server. Output from that should be as follows:

```shell
$ git clone https://github.com/nymtech/nym-directory.git
Cloning into 'nym-directory'...
remote: Enumerating objects: 346, done.
remote: Counting objects: 100% (346/346), done.
remote: Compressing objects: 100% (165/165), done.
remote: Total 1375 (delta 212), reused 287 (delta 172), pack-reused 1029
Receiving objects: 100% (1375/1375), 227.17 KiB | 1.34 MiB/s, done.
Resolving deltas: 100% (831/831), done.
$ cd nym-directory
nym-directory$ go run main.go
[GIN-debug] [WARNING] Creating an Engine instance with the Logger and Recovery middleware already attached.

[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
 - using env:	export GIN_MODE=release
 - using code:	gin.SetMode(gin.ReleaseMode)

[GIN-debug] GET    /swagger/*any             --> github.com/swaggo/gin-swagger.CustomWrapHandler.func1 (4 handlers)
[GIN-debug] [WARNING] Since SetHTMLTemplate() is NOT thread-safe. It should only be called
at initialization. ie. before any route is registered or the router is listening in a socket:

	router := gin.Default()
	router.SetHTMLTemplate(template)

[GIN-debug] GET    /                         --> github.com/nymtech/nym-directory/server.New.func1 (4 handlers)
[GIN-debug] GET    /ws                       --> github.com/nymtech/nym-directory/server.New.func2 (4 handlers)
[GIN-debug] GET    /api/healthcheck          --> github.com/nymtech/nym-directory/healthcheck.(*controller).HealthCheck-fm (4 handlers)
[GIN-debug] POST   /api/metrics/mixes        --> github.com/nymtech/nym-directory/metrics.(*controller).CreateMixMetric-fm (4 handlers)
[GIN-debug] GET    /api/metrics/mixes        --> github.com/nymtech/nym-directory/metrics.(*controller).ListMixMetrics-fm (4 handlers)
[GIN-debug] POST   /api/presence/coconodes   --> github.com/nymtech/nym-directory/presence.(*controller).AddCocoNodePresence-fm (4 handlers)
[GIN-debug] POST   /api/presence/mixnodes    --> github.com/nymtech/nym-directory/presence.(*controller).AddMixNodePresence-fm (4 handlers)
[GIN-debug] POST   /api/presence/mixproviders --> github.com/nymtech/nym-directory/presence.(*controller).AddMixProviderPresence-fm (4 handlers)
[GIN-debug] GET    /api/presence/topology    --> github.com/nymtech/nym-directory/presence.(*controller).Topology-fm (4 handlers)
[GIN-debug] Listening and serving HTTP on :8080
```

That last bit of output is quite important. It lets you know that you're now running the Nym directory server on **localhost** port 8080.

---
weight: 20
title: Quickstart
---

# Quickstart

## Install and run in Docker

* Install Docker.
* Install Make.
* `rm -rf build` if you've previously installed Nym.
* `git clone` the code.
* `cd nym`
* `make localnet-build` builds the config directories and docker images
* `docker-compose up -d`

All components should now be running (please file a bug report if not).

## Your first Nym request

 Go to <TODO Jędrzej please put the URL here>, download the sample `nymclient`, and put it somewhere in your `PATH`.

Now run `./nymclient -f localnetdata/localclient/config.toml`.

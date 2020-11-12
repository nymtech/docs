---
title: "Validators"
weight: 30
description: "Nym Validators provide privacy-enhanced credentials based on the testimony of a set of decentralized, blockchain-based issuing authorities."
---

Nym validators secure the network with a staking token, defending the network from Sybil attacks.

Validators also provide privacy-enhanced credentials based on the testimony of a set of decentralized, blockchain-based issuing authorities. Nym validators use a [signature scheme](https://en.wikipedia.org/wiki/Digital_signature) called [Coconut](https://arxiv.org/abs/1802.07344) to issue credentials. This allows Peaps to generate anonymous resource claims through decentralised authorities, then use them with Service Providers.

The validator is built using [Cosmos SDK](https://cosmos.network) and [Tendermint](https://tendermint.com).

## Building and running

Prerequisites:

* [go](https://golang.org) (1.15)
* make

Build the validator node and cli:

```
git clone https://github.com/nymtech/nym-validator/
cd nym-validator
git checkout v0.9.0 # <-- very important!
make build
```

These commands will produce two binaries (`nymd` and `nymcli`) in the `build` directory. Copy both of them up to your server.

#### Single node setup

Next, generate the initial chain setup:

```
./nymd init your-node-name --chain-id nym-testnet
./nymcli keys add validator-key
./nymcli keys show validator-key
./nymd add-genesis-account $(./nymcli keys show validator-key -a) 1000000000nym,1000000000stake
./nymd gentx --name validator-key --amount 10000000stake
./nymd  collect-gentxs
```

Lastly, start the chain and REST API:

```
./nymd start
./nymcli rest-server --chain-id nym-testnet
```

At this point, you'll be running a single-node validator with a REST API on http://localhost:8081/swagger/index.html, a different (Cosmos) REST API on http://localhost:1317. These two will be merged in the next release. First we want to get the validators and mixnet running, then we'll join them together once all the node types are working :).

## Testnet setup

Joining the testnet starts out similarly to doing the single-node setup:

```
./nymd init your-node-name --chain-id nym-testnet
./nymcli keys add validator-key
./nymcli keys show validator-key
```

Copy and overwrite the `genesis.json` from this repository into place at `~/.nymd/config/genesis.json`. 

Then add the testnet seeds into the `persistent_peers` settings in `~/.nymd/config/config.toml`

```
persistent_peers = "b5eb919e8770dfb6c01e6e3832b7f37d829cc823@testnet-validator1.nymtech.net:26656,4f8b7653057c866c477fd5d4ff7983b8e14bf9dc@testnet-validator2.nymtech.net:26656"
```

Reset the chain to be sure you start fresh:

```
./nymd unsafe-reset-all
```

Start the node:

```
./nymd start
```

Make sure that you have opened the port 26656 on your firewall. If you're using `ufw`, the command is:

```
ufw allow 26656/tcp
```

At this point, your node should start syncing. Wait until the blockchain is fully synced before creating your validator. 

You can check your status using `./nymcli status`. Check to find the latest block height and whether it's currently catching up blocks. If you see:

```
"catching_up": false
```

Then your chain has fully synced.

Ask for nym tokens in the `nymtech.friends#validators` channel in Keybase (hit up @hansbricks or @alexis_roussel). Creating a validator requires that you have enough coins to stake on the validator (minimum is currently 1 million nyms). Note: we will be resetting the testnet chain before the next release, the tokens on it have no value.

Once you've received some (fake) testnet nyms, you can create your validator and join the active set. 

You'll need your validator node pubkey. You can get it by running the `nymd tendermint show-validator` command. The validator pubkey always starts with `nymvalconspub`. Here's an example

```
nym@localhost:~$ ./nymd tendermint show-validator
nymvalconspub1zcjduepql2m3ufcqxf53vyklqwt53ujdz5tcrgnxs8dekuz9s02muc0z68ssvhcllg
```


Next, spend the coins in your account to create a validator. Enter your validator pubkey starting with `nymvalconspub` into the `--pubkey` field, and pick a moniker (self-assigned name) for your validator, like this:

```
nymcli tx staking create-validator --amount=1000001nym --pubkey=nymvalconspub1zcjduepql2m3ufcqxf53vyklqwt53ujdz5tcrgnxs8dekuz9s02muc0z68ssvhcllg  --moniker=YourName --chain-id=nym-testnet --commission-rate="0.10"  --commission-max-rate="0.20"   --commission-max-change-rate="0.01"    --min-self-delegation="1"  --from=validator-key
```

You can check if it worked using: 

```
./nymcli query staking validators
```

This shows the tokens and delegator shares. You should see multiple other validators there. If not, please ask for help in nymtech.friends#validators in KeyBase.

If you want to run your validator automatically at system boot time, you can [adapt the systemd unit file](https://www.digitalocean.com/community/tutorials/understanding-systemd-units-and-unit-files) in `scripts/nym-validator.service` to your needs.
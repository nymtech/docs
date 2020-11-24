---
title: "Mixnodes"
weight: 30
description: "Mixnodes accept Sphinx packets, shuffle packets together, and forward them onwards, providing strong anonymity for internet users."
---


{{% notice info %}}
The Nym mixnode was built in the [building nym](/docs/run-nym-nodes/build-nym/) section. If you haven't yet built Nym and want to run the code, go there first.
{{% /notice %}}

To join the Nym testnet as a mixnode, copy the `nym-mixnode` binary from the `target/release` directory up to your server (or compile it on the server).

### Upgrading from an earlier version

If you have already been running a node on the Nym network v0.8.1, you can use the `upgrade` command to upgrade your configs in place. 

```shell
nym-mixnode upgrade --id your-node-id --current-version 0.8.1
```

If you are participating in the Nym incentives program, you can enter your Liquid or Ethereum address to receive your NYMPH tokens during `upgrade` by using the `--incentives flag`:

```shell
nym-mixnode upgrade --id your-node-id --current-version 0.8.1 --incentives-address YOURADDRESSHERE
```


### Initialize a mixnode

If you are new to Nym, here's how you initialize a mixnode:

```shell
nym-mixnode init --id winston-smithnode --host $(curl ifconfig.me) --location YourCity
```

To participate in the Nym testnet, `--host` must be publicly routable on the internet. It can be either an Ipv4 or IPv6 address. Your node *must* be able to send TCP data using *both* IPv4 and IPv6 (as other nodes you talk to may use either protocol). The above command gets your IP automatically using an external service `$(curl ifconfig.me)`. Enter it manually if you don't have `curl` installed.

The `--location` flag is optional but helps us debug the testnet. 

You can pick any `--id` you want.

When you run `init`, configuration files are created at `~/.nym/mixnodes/<your-id>/`. 

The `init` command will refuse to destroy existing mixnode keys.

If you are participating in the Nym incentives program, you can enter your Liquid or Ethereum address to receive your NYMPH tokens during `init` by using the `--incentives--address` flag:

```shell
nym-mixnode init --id winston-smithnode --host $(curl ifconfig.me) --location YourCity --incentives-address YOURADDRESSHERE
```

### Run the mixnode

`nym-mixnode run --id winston-smithnode`


You should see a nice clean startup: 

```
     | '_ \| | | | '_ \ _ \
     | | | | |_| | | | | | |
     |_| |_|\__, |_| |_| |_|
            |___/

             (mixnode - version 0.9.1)

    
Starting mixnode winston-smithnode...

Directory server [presence]: https://testnet-validator1.nymtech.net
Directory server [metrics]: https://metrics.nymtech.net
Listening for incoming packets on 167.70.75.75:1789
Announcing the following socket address: 167.70.75.75:1789
Public key: HHWAJ1zwpbb1uPLCvoTCUrtyUEuW9KKbUUnz3EUF1Xd9

 2020-05-05T16:01:07.802 INFO  nym_mixnode::node > Starting nym mixnode
 2020-05-05T16:01:08.135 INFO  nym_mixnode::node > Starting packet forwarder...
 2020-05-05T16:01:08.136 INFO  nym_mixnode::node > Starting metrics reporter...
 2020-05-05T16:01:08.136 INFO  nym_mixnode::node > Starting socket listener...
 2020-05-05T16:01:08.136 INFO  nym_mixnode::node > Starting presence notifier...
 2020-05-05T16:01:08.136 INFO  nym_mixnode::node > Finished nym mixnode startup procedure - it should now be able to receive mix traffic!
```

If everything worked, you'll see your node running at https://testnet-explorer.nymtech.net. 

Note that your node's public key is displayed during startup, you can use it to identify your node in the list.

Keep reading to find our more about configuration options or troubleshooting if you're having issues. There are also some tips for running on AWS and other cloud providers, some of which require minor additional setup.

{{% notice info %}}
If you run into trouble, please ask for help in the channel **nymtech.friends#general** on [KeyBase](https://keybase.io).
{{% /notice %}}

Have a look at the saved configuration files to see more configuration options.

### Set the ulimit

{{% notice info %}}
You **must** do the following or your node won't work properly in the testnet.
{{% /notice %}}

**tl;dr:** Paste `DefaultLimitNOFILE=65535`  at the end of `/etc/systemd/system.conf` and reboot your machine.

#### Longer explanation

Linux machines limit how many open files a user is allowed to have. This is called a `ulimit`.

`ulimit` is 1024 by default on most systems. It needs to be set higher, because mixnodes make and receive a lot of connections to other nodes.

You will see a lot of info on the internet about how to check your `ulimit`. There is only one way that's actually reliable. With your node running, first find its process ID:

```
ps aux | grep nym-mixnode
```

This should give back something like: 

```
nym        628  1.0  2.0 171432 20648 ?        Ssl  15:32   0:10 /home/nym/nym-mixnode run --id mix090
```

The first entry `nym` is the user running the process. The second entry, `628`, is the process ID. 

Find out what the `ulimit` is for that process:

```
cat /proc/628/limits # <-- substitute your process ID instead of 628
Limit                     Soft Limit           Hard Limit           Units     

Max open files            1024                 1024                 files # <-- We have a problem. ulimit of 1024 too low!

```

Check the value for `Max open files`. If either your hard or soft limit is 1024, things aren't going to work.

#### Symptoms of ulimit problems

If you see any references to `Too many open files`:

```
Failed to accept incoming connection - Os { code: 24, kind: Other, message: "Too many open files" }
```

This means that the operating system is preventing network connections from being made. Raise your `ulimit`.


### Making a systemd startup script

```
[Unit]
Description=Nym Mixnode (0.9.1)

[Service]
User=nym
ExecStart=/home/nym/nym-mixnode run --id mix090
KillSignal=SIGINT # gracefully kill the process when stopping the service. Allows node to unregister cleanly.
Restart=on-failure
RestartSec=30
StartLimitInterval=350
StartLimitBurst=10

[Install]
WantedBy=multi-user.target
```

Put the above file onto your system at `/etc/systemd/system/nym-mixnode.service`. 

Change the path in `ExecStart` to point at your mixnode binary, and the `User` so it is the user you are running as. Typing `whoami` will tell you who your user is if you're not sure.

Then run:

```
systemctl enable nym-mixnode.service
```

Then start your node: 

```
service nym-mixnode start
```

This will cause your node to start at system boot time. If you restart your machine, the node will come back up automatically. 

You can also do `service nym-mixnode stop` or `service nym-mixnode restart`. 


### Checking that your node is mixing correctly

Once you've started your mixnode and it connects to the testnet validator at http://testnet-validator1.nymtech.net:8081, your node will automatically show up in the [Nym testnet explorer](https://testnet-explorer.nymtech.net).

The Nym network will periodically send two test packets through your node (one IPv4, one IPv6), to ensure that it's up and mixing. In the current version, this determines your node reputation over time (and if you're participating in the incentives program, it will set your node's reputation score). 

If your node is not mixing correctly, you will notice that its status is not green. Ensure that your node handles both IPv4 and IPv6 traffic, and that its public `--host` is set correctly. If you're running on cloud infrastructure, you may need to explicitly set the `--announce-host` (see below).


### Viewing command help

See all available options by running:

```
nym-mixnode --help
```

Subcommand help is also available, e.g.:

```
nym-mixnode upgrade --help
```


### Node registration and de-registration

When your node starts up, it notifies the rest of the Nym network that it is up and ready to mix traffic. Token rewards will start as soon as registration has taken place. But if your node isn't mixing properly, you'll start to incur reputation penalties. 

If you run your node in a console window, it will register when it starts up, and un-register automatically when you hit `ctrl-c` to stop it. When your node is unregistered, it will not gain reputation, but it won't lose any either. 

If you kill it, though (`kill <process-number>`), the un-registration will not happen and you will incur reputation penalties. So, use `ctrl-c` instead.

Most people will want to run their mixnodes as a systemd service instead of in a console. Systemd scripts by default send `KillSignal=SIGTERM`, which kills the process non-gracefully, so that the un-registration doesn't happen. 

You **must** use `KillSignal=SIGINT` in your systemd scripts, under the `[Service]` block. This allows the un-registration code to run whenever your service is stopped. 

#### Manual unregister

If you just want to unregister your node, you can do so with the `unregister` command:

```
nym-mixnode unregister --id mix090  # substitute your node id here.
```


### Virtual IPs, Google, AWS, and all that

On some services (e.g. AWS, Google), the machine's available bind address is not the same as the public IP address. In this case, bind `--host` to the local machine address returned by `ifconfig`, but also specify `--announce-host` with the public IP. Please make sure that you pass the correct, routable `--announce-host`.

For example, on a Google machine, you may see the following output from the `ifconfig` command:

```
ens4: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1460
        inet 10.126.5.7  netmask 255.255.255.255  broadcast 0.0.0.0
        ...
```

The `ens4` interface has the IP `10.126.5.7`. But this isn't the public IP of the machine, it's the IP of the machine on Google's internal network. Google uses virtual routing, so the public IP of this machine is something else, maybe `36.68.243.18`.

`nym-mixnode init --host 10.126.5.7`, inits the mixnode, but no packets will be routed because `10.126.5.7` is not on the public internet.

Trying `nym-mixnode init --host 36.68.243.18`, you'll get back a startup error saying `AddrNotAvailable`. This is because the mixnode doesn't know how to bind to a host that's not in the output of `ifconfig`.

The right thing to do in this situation is `nym-mixnode init --host 10.126.5.7 --announce-host 36.68.243.18`.

This will bind the mixnode to the available host `10.126.5.7`, but announce the mixnode's public IP to the directory server as `36.68.243.18`. It's up to you as a node operator to ensure that your public and private IPs match up properly.



### Mixnode Hardware Specs

For the moment, we haven't put a great amount of effort into optimizing concurrency to increase throughput. So don't bother provisioning a beastly server with many cores. 

* Processors: 2 cores are fine. Get the fastest CPUs you can afford. 
* RAM: Memory requirements are very low - typically a mixnode may use only a few hundred MB of RAM. 
* Disks: The mixnodes require no disk space beyond a few bytes for the configuration files

This will change when we get a chance to start doing performance optimizations in a more serious way. Sphinx packet decryption is CPU-bound, so once we optimise, more fast cores will be better.
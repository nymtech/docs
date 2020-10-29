---
title: "Troubleshooting FAQ"
weight: 30
description: "This page will help you find answers to common issues with setting up and maintaining mixnodes"
---






{{< table_of_contents >}}

## How to install a mixnode?
There are multiple ways on how to install a mixnode. Depending on your experience or needs, you may choose either option. The easiest and fastest way is to use the installer script or Docker contaier if you know some Docker basics. 

### Build Nym from source

For a bit more advanced users, who want to compile all Nym binaries themselves or just want to get a specific precompiled one from the official Github repo go to [Quickstart](https://nymtech.net/docs/quickstart/). 

### Installer script

This community script created by [@hansbricks](https://github.com/gyrusdentatus) installs all dependencies, downloads Nym-mixnode binaries, promts user for the input for the mixnode configuration
, creates a systemd.service file based on the user input, enables ufw and nym-mixnode.service and then launches the node.
Nym-mixnode is being launched by systemctl with a newly created user *nym* from */home/nym/* directory. 

More info [here](https://github.com/gyrusdentatus/nym_autoinstall)

### Docker images

We currently do not have an official Docker image, although there exist at least two community images. Decide for yourself whichever suits your needs better. 

- Unofficial minimal image created by [@snekone](https://github.com/snek). You can get it from [Dockerhub](https://hub.docker.com/r/snekone/nym-mixnode-docker). Visit the page to see full documentation. 


<a name="ismixing" />

## How can I tell my node is up and running and mixing traffic?

if you see your node on the [dashboard](dashboard.nymtech.net) then you are all good. 

But you might prefer to stay in your terminal and check your node from there.

There are multiple ways how to do that.

### To check from the machine your node is running on:

- ``` sudo ss -s -t | grep 1789 ``` This should work on every unix based system
- ``` sudo lsof -i TCP:1789 ``` if you get command not found, do ``` sudo apt install lsof ```

### To double check from your local machine

-  ``` telnet <IP ADDRESS> 1789<OR OTHER PORT> ```
-  ``` nmap -p 1789 <IP ADDRESS> -Pn ```

This won't tell you much but as long as your telnet connetion does not hang on "**Trying ...**" it should mean your mixnode is accessible from the outside.

This is how an output from above **nmap** command should look like if your mixnode is configured properly :

```
hans@desktop:~$ nmap -p 1789 95.296.134.220 -Pn

Host is up (0.053s latency).

PORT     STATE SERVICE
1789/tcp open  hello

```



You can get a lot of further info with a little help of **jq**
jq is also very nice to use if you are able to install it or have it already

- ``` curl https://directory.nymtech.net/api/presence/topology | jq ```

you can parse it further then

for instance - get all ip addresses of nodes with *--location* Finland 

- ``` curl https://directory.nymtech.net/api/presence/topology | jq -r '.mixNodes[] | select(.location | startswith("Finland")) | .host' ```

or get your pub key if you know your ip 

- ``` curl https://directory.nymtech.net/api/presence/topology | jq -r '.mixNodes[] | select(.host | startswith("<IP ADDRESS>")) | .pubKey' ```

***



## Why is my node not mixing any packets & Setting up the firewall

If you are unable to see your node on the [dashboard](dashboard.nymtech.net) or with other above mentioned ways to check up on your node then it is usually quite simple and straightforward to solve this issue.
The most probable reason being :
* Firewall on your host machine is not configured.
* Not using *--anounce-host* flag while running mixnode from your local machine behind NAT.
* You did not configure your router firewall while running the mixnode from your local machine behind NAT or you are lacking IPv6 support. Your mixnode **must speak both IPv4 and IPv6**. You will need to cooperate with other nodes in order to route traffic.
* Mixnode is not running at all, it either exited or you closed the session without making the node persistent.

**Check your firewall settings on your host machine. Easiest way on your VPS is to use ```ufw``` 
 On some systems, like Debian 10 server, ```ufw``` is not installed by default**
- as a root user on Debian 10 install ufw - ```apt install ufw -y ``` 
- On Ubuntu, first check if your ufw is enabled - ```ufw status ```
-  ``` ufw allow 1789/tcp && ufw allow 22/tcp && ufw enable ```  - > This will allow port 1789 for the mixnode, 22 for ssh and then enables the firewall. Your node should work right after that.
**Note**: You need to add ```sudo ``` before each ```ufw ``` command if you're not a root user. ```sudo ufw allow 1789/tcp ```. The ```&&``` symbols are used to chain together commands in Linux. 
- The installer script takes care of the firewall settings, so if you are not sure what you're doing then simply use the install script mentioned in the first section about installation. 



## How can I make sure my node works from my local machine if I'm behind NAT and have no fixed IP address ?

First of all, your ISP has to be IPv6 ready. Sadly, in 2020, most of them are not and you won't get an IPv6 address by default from your ISP. Usually it is a extra paid service or they simply don't offer it. 

Before you begin, check if you have IPv6 [here](https://test-ipv6.cz/). If not, then don't waste your time to run a node which won't ever be able to mix any packet due to this limitation. Call your ISP and ask for IPv6, there is a plenty of it for everyone!

If all goes well and you have IPv6 available, then you will need to ```init``` the mixnode with an extra flag, ```--announce-host```. You will also need to edit your **config** file each time your IPv4 address changes, that could be a few days or a few weeks. 

Additional configuration on your router might also be needed to allow traffic in and out to port 1789 and IPv6 support.

Here is a sample of the `init` command to create the mixnode config.

``` 
./target/release/nym-mixnode init --id nym-nat --host 0.0.0.0 --announce-host 85.160.12.13 --layer 3 --location Mars 
```

- `--host 0.0.0.0` should work everytime even if your local machine IPv4 address changes. For example on Monday your router gives your machine an address `192.168.0.13` and on Wednesday, the DHCP lease will end and you will be asigned `192.168.0.14`. Using `0.0.0.0` should avoid this without having to set any static ip in your router`s configuration.
- you can get your current IPv4 address by either using `curl ipinfo.io` if you're on MacOS or Linux or visiting [whatsmyip site](https://www.whatsmyip.org/). Simply copy it and use it as `--anounce-host` address.

Make sure you check if your node is really mixing. You will need a bit of luck to set this up from your home behind NAT. 



## Can I use a different port other than 1789 ?

Yes! Here is what you will need.
Let's say you would like to use port **1337** for your mixnode. 

### Configuring the firewall 

`sudo ufw allow 1337` (run without sudo if you are root). More details about this can be found in the **Why is my node not mixing any packets & Setting up the firewall** section of this wiki.

### Edit existing config 

If you already have a config you created before and want to change the port, you need to stop your node if it's running and then edit your config file. 
Assuming your node name is `nym`, the config file is located at `~/.nym/mixnodes/nym/config/config.toml`. 
```
nano ~/.nym/mixnodes/nym/config/config.toml 
```
You will need to edit two parts of the file. `announce_address` and `listening_address` in the config.toml file. Simply find these two parts, delete your former port `:1789` and append `:1337` after your IP address.

To save the edit, press `CTRL+O` and then exit `CTRL+X`. Then run the node again. You should see if the mixnode is using the port you have changed in the config.toml file right after you run the node. 

Here is an example of my test run.

```
hans@desktop:~/.nym/mixnodes/nym-nat/config$ ~/nym/target/release/./nym-mixnode run --id 1337


      _ __  _   _ _ __ ___
     | '_ \| | | | '_ \ _ \
     | | | | |_| | | | | | |
     |_| |_|\__, |_| |_| |_|
            |___/

             (mixnode - version 0.8.1)

    
Starting mixnode 1337...
Public sphinx key: 88xXcYUPtTbDwQWo4zacCFCFiQmH2f7Hf5pAkcmDTkDH

Directory server [presence]: https://directory.nymtech.net
Directory server [metrics]: https://directory.nymtech.net
Listening for incoming packets on 13.37.13.37:1337
Announcing the following socket address: 13.37.13.37:1337
 2020-10-25T18:43:15.499 INFO  nym_mixnode::node > Starting nym mixnode
 2020-10-25T18:43:16.355 INFO  nym_mixnode::node > Starting packet forwarder...
 2020-10-25T18:43:16.355 INFO  nym_mixnode::node > Starting metrics reporter...
 2020-10-25T18:43:16.363 INFO  nym_mixnode::node > Starting socket listener...
 2020-10-25T18:43:16.363 INFO  nym_mixnode::node > Starting presence notifier...
 2020-10-25T18:43:16.368 INFO  nym_mixnode::node > Finished nym mixnode startup procedure - it should now be able to receive mix traffic!


```

You may see the port is now `1337`. 


## Where can I find my private and public keys and mixnode config?

All config and keys files are stored in a directory named after your `id` which you chose during the *init* configuration with a following PATH: `$HOME/.nym/mixnodes/` where `$HOME` is a home directory of the user (your current user in this case) that launched the mixnode.

Depending on how you installed Nym, the files will be stored here:

1. Autoinstaller - `/home/nym/.nym/mixnodes/<YOURNODEID>`
2. Built from source as your user or root - `~/.nym/mixnodes/<YOURNODEID>`
3. Docker - .... *to be discussed tomorrow during the meeting*

The directory structure looks as following:

```
hans@desktop:~/.nym/mixnodes/nym-nat/config$ tree ../
../
├── config
│   └── config.toml
└── data
    ├── private_sphinx.pem
    └── public_sphinx.pem

2 directories, 3 files

```

**Note:** If you `cat` the public_sphinx.pem key, the output will be different from the public key you will see on Nym [dashboard](dashboard.nymtech.net). Reason being `.pem` files are encoded in **base64**, however; on web they are in different encoding - **base58**. Don't be confused if your keys look different. They are the same keys, just with different encoding :). 


## I keep seeing ERROR or WARN messages in my node logs. Why is that ?

I have seen quite a few errors from community members in our [Telegram help chat](https://t.me/nymchan_help_chat).

Most of them are benign. Usually you will encounter errors when your nodes tries to estabilish a connection with a "dead" node, that is misconfigured(most likely its firewall is).

As long as your node outputs `since startup mixed 1337 packets!` in your logs, you should be fine. If you want to be sure, check the Nym [dashboard](dashboard.nymtech.net) or see other ways on how to check if your node is really mixing, mentioned in section **How can I tell my node is up and running and mixing traffic?** in this wiki. 




## I compiled Nym from source. How do I make the mixnode run in the background?

When you close current session, you kill the process and therefore the mixnode will stop. There are multiple ways on how to make it persistent even after exiting your ssh session. Tmux, screen for instance. 

Easy solution would be to use **nohup** -> ```nohup`./nym-mixnode run --id NYM & ``` where `--id NYM` is the id you set during the *init* command previously. 

**However**, the **most reliable** and **elegant solution** is to create a **systemd.service** file and run the nym-mixnode with `systemctl` command.

Credits to [ststefa](https://github.com/ststefa) for writing this file. 

Create a file with nano and copy there following. 
**IMPORTANT:** You need to write there your node id which you set up in the config earlier, else it won't work!
At line ExecStart, rewrite the --id SOMENAME with exactly the same name as you used for the config.

``` sudo nano /etc/systemd/system/nym-mixnode.service ```

Copy there this and change the id name 


```
[Unit]
Description=nym mixnode service
After=network.target

[Service]
Type=simple
User=nym
Group=nym
ExecStart=/home/nym/nym/target/release/nym-mixnode run --id SOMENAME
Restart=on-abort

[Install]
WantedBy=multi-user.target
```

Now pres CTRL + O to write the file, hit enter. Then exit with CTRL + W.

```sudo systemctl enable nym-mixnode ```

- Enable the service 

```sudo systemctl start nym-mixnode ```

- Start the service

```sudo systemctl status nym-mixnode ```

- Check if the service is running properly and mixnode is mixing. 

Now your node should be mixing all the time unless you restart the server!


## Where can I get more help?

The fastest way to reach one of us or get a help from the community, visit our [Telegram help chat](https://t.me/nymchan_help_chat).

For more tech heavy questions join our Keybase channel. Get Keybase [here](https://keybase.io/), then click Teams -> Join a team. Type nymtech.friends into the team name and hit continue. For general chat, hang out in the #general channel. Our development takes places in the #dev channel. Node operators should be in the #node-operators channel to receive notice of system updates or node downtime.

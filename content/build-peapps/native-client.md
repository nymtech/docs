---
title: "Native client"
weight: 40
description: "How to run the Nym native network client on a desktop or server machine."
---

{{% notice info %}}
The Nym Native Client was built in the [quickstart](/docs/quickstart) section. If you haven't yet built Nym and want to run the code on this page, go there first.
{{% /notice %}}

From inside the `nym` directory, the `nym-client` binary got built to the `./target/release/` directory. You can run it like this:

`./target/release/nym-client`

```shell
$ ./target/release/nym-client 


      _ __  _   _ _ __ ___
     | '_ \| | | | '_ \ _ \
     | | | | |_| | | | | | |
     |_| |_|\__, |_| |_| |_|
            |___/

             (client - version 0.7.0)

    
usage: --help to see available options.
```

There are two commands you can issue to the client.

1. `init` - initialize a new client instance. Requires `--id clientname` parameter.
2. `run` - run a mixnet client process. Requires `--id clientname` as a parameter


## Initializing a new client instance

Before you can use the client, you need to initialize a new instance of it. Each instance of the client has its own public/private keypair, and connects to its own gateway node. Taken together, these 3 things (public/private keypair + gateway node) make up a peap's identity.

Initing a new client instance can be done with the following command:

```shell
./target/release/nym-client init --id alice
```

When you initialize a client instance, a configuration directory will be generated and stored in `$HOME_DIR/.nym/clients/<client-name>/`. 

```shell
$ tree ~/.nym/clients/alice/
/home/dave/.nym/clients/alice/
├── config
│   └── config.toml
└── data
    ├── private_identity.pem
    └── public_identity.pem
```

The file `config.toml` contains client configuration options, while the two `pem` files contain client key information. 

Have a look at the generated files if you'd like - they contain the client name, public/private keypairs, and gateway address. The name `alice` in the example above is just a local identifier so that you can name your clients; it is never transmitted over the network.

## Running the native client

You can run the client for user `alice` by doing this:

```shell
./target/release/nym-client run --id alice
```

When you run the client, it immediately starts generating (fake) cover traffic and sending it to the Nym testnet.

{{% notice info %}}
Congratulations, you have just contributed a tiny bit of privacy to the world! `<CTRL-C>` to stop the client.
{{% /notice %}}

When the client is first started, it will reach out to the Nym network's directory systems, and get a list of available Nym nodes (gateways, mixnodes, and validators). We call this list of nodes the network *topology*. The client does this so that it knows how to connect, register itself with the network, and know which mixnodes it can route Sphinx packets through.

Once the client has obtained the network topology, it automatically sends a registration request to one of the first available gateway. The gateway returns a unique authentication token that the client attaches to every subsequent request to the gateway.

### Connecting to the local websocket 

The Nym native client exposes a websocket interface that your code connects to. To program your peap, choose a websocket library for whatever language you're using. The default websocket port is `1977`, you can override that in the client config if you want.

## A simple example peap


Let's write some code. Sometimes when you're learning something new it's easiest to see a short working example. Here's a simple peap written in Python. This example is packaged with the Nym platform, dig around in the `python-examples` directory inside `clients/native` 

```python
import asyncio
import json
import websockets

self_address_request = json.dumps({
    "type": "selfAddress"
})

async def send_text():
    message = "Hello Nym!"

    uri = "ws://localhost:1977"
    async with websockets.connect(uri) as websocket: # 1
        await websocket.send(self_address_request)
        self_address = json.loads(await websocket.recv())
        print("our address is: {}".format(self_address["address"]))

        text_send = json.dumps({ # 2 
            "type": "send",
            "message": message,
            "recipient": self_address["address"]
        })

        print("sending '{}' over the mix network...".format(message))
        await websocket.send(text_send) # 3
        msg_send_confirmation = json.loads(await websocket.recv()) # 4
        assert msg_send_confirmation["type"], "send"

        print("waiting to receive a message from the mix network...")
        received_message = await websocket.recv() # 5
        print("received {} from the mix network!".format(received_message))

asyncio.get_event_loop().run_until_complete(send_text())
```

The Python code does the following. 

1. connects to the websocket on port 1977
2. formats a message to send. Nym messages have defined JSON formats.
3. sends the message into the websocket. The native client packages the message into a Sphinx packet and sends it to the mixnet
4. waits for confirmation that the message hit the native client
5. waits to receive messages from other Nym peaps

By varying the message content, you can easily build sophisticated Service Provider peaps. For example, instead of `print("received {} from the mix network!".format(received_message))` your Service Provider might take some action on behalf of the user - perhaps initiating a network request, a blockchain transaction, or writing to a local data store. 

## Message Types

There are a small number of messages that your application sends up the websocket to interact with the native client, as follows.

#### Sending text

If you want to send text information through the mixnet, format a message like this one and poke it into the websocket:

```json
{
  "type": "send",
  "message": "the message",
  "recipient_address": "71od3ZAupdCdxeFNg8sdonqfZTnZZy1E86WYKEjxD4kj@FWYoUrnKuXryysptnCZgUYRTauHq4FnEFu2QGn5LZWbm"
}
```

In some applications, e.g. where people are chatting with friends who they know, you might want to include unencrypted reply information in the message field, like so:


```json
{
  "type": "send",
  "message":
      {
        "sender": "198427b63ZAupdCdxeFNg8sdonqfZTnZZy1E86WYKEjxD4kj@FWYoUrnKuXryysptnCZgUYRTauHq4FnEFu2QGn5LZWbm",
        "chatMessage": "hi julia!"
      },
  "recipient_address": "71od3ZAupdCdxeFNg8sdonqfZTnZZy1E86WYKEjxD4kj@FWYoUrnKuXryysptnCZgUYRTauHq4FnEFu2QGn5LZWbm"
}
```

This provides an easy way for the receiving chat to then turn around and send a reply message:

```json
{
  "type": "send",
  "message":
      {
        "sender": "71od3ZAupdCdxeFNg8sdonqfZTnZZy1E86WYKEjxD4kj@FWYoUrnKuXryysptnCZgUYRTauHq4FnEFu2QGn5LZWbm",
        "chatMessage": "winston, so lovely to hear from you! shall we meet at the antiques shop?"
      },
  "recipient_address": "198427b63ZAupdCdxeFNg8sdonqfZTnZZy1E86WYKEjxD4kj@FWYoUrnKuXryysptnCZgUYRTauHq4FnEFu2QGn5LZWbm"
}
```

If that fits your security model, good. However, it may be the case that you want to send anonymous replies using Single Use Reply Blocks, or *surbs*. These will be available in the next version of Nym (0.8.0).


#### Sending binary data

You can also send bytes instead of JSON. A Python program to send a file `dummy_file` looks like this:

```python
async def send_file():
    uri = "ws://localhost:1977"
    async with websockets.connect(uri) as websocket:
        await websocket.send(self_address_request)
        self_address = json.loads(await websocket.recv())
        print("our address is: {}".format(self_address["address"]))

        # We receive our address in string format of 
        # OUR_PUB_KEY @ OUR_GATE_PUB_KEY
        #
        # Both keys are 32 bytes and we need to encode them as binary 
        # without the '@' sign
        split_address = self_address["address"].split("@")
        bin_payload = bytearray(base58.b58decode(split_address[0]))
        bin_payload += base58.b58decode(split_address[1])

        with open("dummy_file", "rb") as input_file:
            read_data = input_file.read()
            bin_payload += read_data

        print("sending content of 'dummy_file' over the mix network...")
        await websocket.send(bin_payload)
        msg_send_confirmation = json.loads(await websocket.recv())
        assert msg_send_confirmation["type"], "send"

        print("waiting to receive the 'dummy_file' from the mix network...")
        received_data = await websocket.recv()
        with open("received_file", "wb") as output_file:
            print("writing the file back to the disk!")
            output_file.write(received_data)

asyncio.get_event_loop().run_until_complete(send_file())
```

In order to send binary messages, you format a 64-byte binary array, with the first 32 bytes being the recipient pubkey, and the second 32 bytes being the destination gateway pubkey. The remainder of the payload is the bytes of the binary data you'd like to send.  

#### Receiving messages

When another peap sends a message to you, all extraneous information is stripped and you just get the message. So if a peap sends the following message:

```json
{
  "type": "send",
  "message": "2 + 2 = 4",
  "recipient_address": "71od3ZAupdCdxeFNg8sdonqfZTnZZy1E86WYKEjxD4kj@FWYoUrnKuXryysptnCZgUYRTauHq4FnEFu2QGn5LZWbm"
}
```

The receiving user will get only `2 + 2 = 4`. 

#### Getting your own address

Sometimes, when you start your peap, it can be convenient to ask the native client to tell you what your own address is (from the saved configuration files). To do this, send:

```json
{
  "type": "selfAddress"
}
```

You'll get back:

```json
{
      "type": "selfAddress",
      "address": "the-address"
}

```

#### Error messages

Errors from the peap's client, or from the gateway, will be sent down the websocket to your code in the following format:


```json 
{
      "type": "error", 
      "message": "string message"
}
```
---
title: "Mixnet client"
weight: 50
description: "How to build and run the Nym mixnet-client."
---


This whole clients section should be changed to a tutorial format, and separated into 3 guides:

* getting started developing a desktop application
* getting started developing a web / mobile application using WebAssembly
* (later) getting started developing a mobile application using the cross-compiled mobile client from Roberto

### Clients

{{% notice info %}}
The Nym Client was built in the [Installation](../installation) section. If you haven't yet built Nym and want to run the code on this page, go there first.
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

Let's try it out. First, you need to initialize a new client.

`./target/release/nym-client init --id alice`

```
      _ __  _   _ _ __ ___
     | '_ \| | | | '_ \ _ \
     | | | | |_| | | | | | |
     |_| |_|\__, |_| |_| |_|
            |___/

             (client - version 0.7.0)

    
Initialising client...
 2020-05-26T18:45:32.098 INFO  pemstore::pemstore > Written private key to "~/.nym/clients/alice/data/private_identity.pem"
 2020-05-26T18:45:32.099 INFO  pemstore::pemstore > Written public key to "~/.nym/clients/alice/data/public_identity.pem"
Saved mixnet identity keypair
Saved configuration file to "~/.nym/clients/alice/config/config.toml"
Unless overridden in all `nym-client run` we will be talking to the following gateway: BfsNG1WGzLYNQwmSoZas969KFnXyKY9pbsQqSDmZWdyQ...
using optional AuthToken: "9XSGi1vR1Xy1HbSaPKNzwQ8gqLgqbDDVudYFr5Khi2xq"
Client configuration completed.
```

Have a look at the generated files if you'd like - they contain the client name, public/private keypairs, etc.

You can run the client for user `alice` by doing this:

`./target/release/nym-client run --id alice`

Output should look something like this:

```shell
$ ./target/release/nym-client run --id alice


      _ __  _   _ _ __ ___
     | '_ \| | | | '_ \ _ \
     | | | | |_| | | | | | |
     |_| |_|\__, |_| |_| |_|
            |___/

             (client - version 0.7.0)


Starting websocket on port: 9001
Listening for messages...
Starting nym client
Using directory server: "https://directory.nymtech.net"
```

When you run the client, it immediately starts generating (fake) cover traffic and sending it to the Nym testnet.

{{% notice info %}}
Congratulations, you have just contributed a tiny bit of privacy to the world! `<CTRL-C>` to stop the client.
{{% /notice %}}

Try stopping and starting the client a few times. If you're interested, you should see your traffic reflected in the network traffic *sent* and *received* metrics at the [Nym Dashboard](https://dashboard.nymtech.net/). Have a look on the right hand side:

![dashboard](/docs/images/dashboard.gif)

### Understanding the client

A large proportion of the Nym mixnet's functionality is implemented client-side, including:

1. determining network topology
1. registering with mixnet's default [store-and-forward providers](../providers)
1. fetching stored messages from the [store-and-forward providers](../providers)
1. sending a constant stream of Sphinx packet *cover traffic* messages
1. sending Sphinx packets with real messages
1. sending Sphinx packet *cover traffic* when no real messages are being sent

#### Determining network topology

The first thing to understand is that it's the local client which picks the path that each packet will take through the mixnet topology.

When you first run your client, the client needs to figure what mixnodes exist, which layers they're in, and their public keys.

The client asks the Nym [directory](../../directory) for the current mixnet topology. The client handles all this automatically, but in order to understand what's happening, you can try it yourself:

```bash
curl -X GET "https://directory.nymtech.net/api/presence/topology" -H  "accept: application/json" | jq
```

This returns a JSON-formatted list of `MixNodes` and `MixProviderNodes`, among other things:

```json
"MixNodes": [
  {
    "host": "52.56.99.196:1789",
    "pubKey": "_ObRUsYnHDJOPDHXyfq5bnIoSbdn3BsSRcrLl-FCY1c=",
    "layer": 2,
    "lastSeen": 1572258570490299400
  },
  {
    "host": "18.130.86.190:1789",
    "pubKey": "dMtoH6vWDBfwjrU0EzPd-fhZDOGJazELsTp2qLyt72U=",
    "layer": 1,
    "lastSeen": 1572258571193777000
  },
  {
    "host": "3.10.22.152:1789",
    "pubKey": "03FFZ5RgfeBPmVVERenJOCLb-yXlOUtstc6izYc-wFs=",
    "layer": 1,
    "lastSeen": 1572258570994450200
  },
  {
    "host": "35.176.155.107:1789",
    "pubKey": "oaEqLzA5nUxMAqfg6yW5pneWC342uDMfVsSHxyNQ-DE=",
    "layer": 3,
    "lastSeen": 1572258571709773800
  },
  {
    "host": "3.9.12.238:1789",
    "pubKey": "ALf35HwBzXZXxaS6V55W7cLsx4a26AaRefinwwJHrg4=",
    "layer": 3,
    "lastSeen": 1572258571616835600
  },
  {
    "host": "35.178.213.77:1789",
    "pubKey": "KlfEn07FzcN93nMzzlsgq3wN5O1ID6O3Pd4DbezHEWo=",
    "layer": 2,
    "lastSeen": 1572258570492776400
  }
],
"MixProviderNodes": [
  {
    "host": "35.178.212.193:1789",
    "pubKey": "R_rGKmwelVAVRpicMwMIJwsHvdYHMNfcItPwNipu5GQ=",
    "registeredClients": [
      {
        "pubKey": "u7UTjC3UNXdz0HsjMKoxozzbvXyi3KrEvl8BxNNPcAM="
      },
     ...
    ],
    "lastSeen": 1572258572070089000
  },
  {
    "host": "3.8.176.11:1789",
    "pubKey": "XiVE6xA10xFkAwfIQuBDc_JRXWerL0Pcqi7DipEUeTE=",
    "registeredClients": [
      {
        "pubKey": "HGTg5XPWe4eiluFKTnC958PuGUSipjLcIeFdLi6zsww="
      },
      ...
    ],
    "lastSeen": 1572258571843881700
  }
],
...
```

The client does this when it starts. Each mixnode reports what layer it's in, its public key, and its IP address. Provider nodes do the same.

The client now has all the information needed to pick a path through the mixnet for each Sphinx packet, and do packet encryption.

#### Registering at a provider

When the client is first started, it sends a registration request to one of the available providers, (see `MixProviderNode` list in the topology). This returns a unique token that the client attaches to every subsequent request to the provider.

This is required as mixnet clients cannot receive messages directly from other clients as this would have required them to reveal their actual IP address which is not a desirable requirement. Instead the providers act as a sort of proxy between the client and the mixnet. So whenever client receives a message, it is stored by the specified provider until the recipient fetches it.

#### Fetching stored messages

Upon completing the provider registration, the client starts a separate message stream that periodically fetches all the client's stored messages on the provider.

{{% notice note %}}
Note that once the message is pulled, the provider immediately deletes it.
{{% /notice %}}

#### Sending messages

Since it now understands the topology of the mixnet, the client can start sending traffic immediately. But what should it send?

If there's a real message to send (because you poked something down the client's inbound socket connection), then the client will send a real message. Otherwise, the client sends cover traffic.

Real messages and cover traffic are both encrypted using the Sphinx packet format, so that they're indistinguishable from each other.

#### Sphinx packet creation

Clients create Sphinx packets. These packets are a bit complicated, but for now all you need to know is that they have the following characteristics:

1. they consist of a header and a body
1. the header contains unencrypted routing data
1. bodies are encrypted
1. bodies are padded so that they're all the same size
1. observers can't tell anything about what's inside the encrypted body
1. the body is layer-encrypted - it may contain either another sphinx packet or a payload message

Now let's build the Nym Mixnode and see what happens when a Sphinx packet hits a mixnode.

## Integrating the mixnet client in your applications

Depending on what language you're using, you can fire up the client in one of two ways: websocket or TCP socket.

### Using the websocket

#### Starting the websocket

Currently, the recommended way of integrating Nym client in your application is by using a websocket. In order to enable this form of connection, you need to either initialize your client with the websocket by adding the following attribute: `--socket-type websocket`. You can also choose a custom port to listen on by passing `--port <port-value>` attribute. So your whole initialization might look like: `nym-client init --id Alice --socket-type websocket --port 1234`

The alternative is to modify your existing client's configuration file, most likely located in `$HOME/.nym/clients/<your-id>/config/config.toml` by changing appropriate values in the `[socket]` section:

{{< highlight toml >}}

##### socket config options #####

[socket]

# allowed values are 'TCP', 'WebSocket' or 'None'
socket_type = "None"

# if applicable (for the case of 'TCP' or 'WebSocket'), the port on which the client
# will be listening for incoming requests
listening_port = 9001

{{< /highlight >}}

Finally, it can all be modified during client start-up by passing the same flags as you would have used during `init`, i.e. `--socket-type websocket` and `--port <port-value>`. So then you might start up your client using websocket (regardless of what is written to its configuration file!) as follows: `nym-client run --id Alice --socket-type websocket --port 1234`

<!-- This notice should probably be put to section regarding client config (once written) -->
{{% notice tip %}}
All start-up attributes take presedence and override whatever is written to the configuration file.
{{% /notice %}}

You will know if you set everything correctly if you see the following message during `nym-client run`: (assuming you did not disable logging)

`INFO  nym_client::sockets::ws                 > Starting websocket listener at 127.0.0.1:9001`

##### Using the Websocket

Once you managed to startup your Websocket listener, there's an important note to make before you connect your application to it.

First of all, only `Text` messages are supported and all `Binary` data will be rejected.

Also, you generally would only ever want to have a single application per Nym Client instance unless you have a very specific use cases. Because while it is entirely possible for multiple clients to be connected simultanously, there are significant consequences of that to keep in mind:

- all applications would share the same underlying key and hence identity, what might or might not be what you want,
- as a consequence of the above, all connections would share the same buffer of inbound messages [from a store-and-forward provider] resulting in application A receiving messages originally expected to be obtained by application B,
- it might take longer for your messages to get sent as everything is sent according to Poisson distribution with constant parameterization regardless of number of messages waiting to get sent.

{{% notice note %}}
Also note that the websocket will **only** accept requests from the loopback address.
{{% /notice %}}

TODO: Talking to Roberto revealed something really interesting: he was trying to figure out "how do I *receive* the address of the sender?" and was stumped. 

It's actually a feature that the sender address isn't sent with all messages (as we have a privacy system). But applications can easily send the sender address, e.g.:

{"sender":"m3bN8BoMXNnBth32tW75a89A6SLiMVq7UbphB6588nz", "message": "hi roberto"}


##### API

Right now the Websocket requests have the following structure:
{{< highlight json >}}
{
  "type": "messageType",
  "messageSpecificFields": ...
}
{{< /highlight >}}

And let you do the following:
{{< highlight json >}}
{
  "type": "send",
  "message": "message content",
  "recipient_address": "base58 encoded recipient address"
}
{{< /highlight >}}
to send a message of specified content to some other client on the network. Do note that the structure is subject to change as currently the message does not include address of the recipient's service provider, which is going to be required to correctly route it when the network contains more than a single store-and-forward provider. And more importantly, to ensure correct transmission, the message field content has to be within 975 bytes.

{{% notice info %}}
The message sent has to be less than 975 bytes as currently we have no implemented chunking yet.
{{% /notice %}}

{{< highlight json >}}
{
  "type": "fetch"
}
{{< /highlight >}}
to fetch all messages that we might have received from other clients [that were already polled from the store-and-forward provider],

{{< highlight json >}}
{
  "type": "getClients"
}
{{< /highlight >}}
to get list of all public clients on the network,

{{< highlight json >}}
{
  "type": "ownDetails"
}

{{< /highlight >}}
to obtain details, i.e. public key/address of this specific Nym client

The responses to those requests follow identical structure, i.e.:
{{< highlight json >}}
{
  "type": "messageType"
  "messageSpecificFields": ...
}
{{< /highlight >}}

And they are respectively:

{{< highlight json >}}
{
  "type": "send"
}
{{< /highlight >}}

{{< highlight json >}}
{
  "type": "fetch",
  "messages": ["received messages"]
}
{{< /highlight >}}

{{< highlight json >}}
{
  "type": "getClients",
  "clients": ["available clients"]
}
{{< /highlight >}}

{{< highlight json >}}
{
  "type": "ownDetails",
  "address": "base58 encoded address"
}
{{< /highlight >}}

{{< highlight json >}}
{
  "type": "error",
  "message": "error message"
}
{{< /highlight >}}

So for example you could do the following to send a message to some other client via Websocket in Typescript:

{{< highlight Typescript >}}

const sendMsg = JSON.stringify({
  type: "send",
  message: "foo",
  recipient_address: "C5ht4YgZ58CGZZ1BNQzh56Fr2S69BkJcbkpK3NpBrHzk",
});

const conn = new WebSocket(`ws://localhost:9001/mix`);
conn.onmessage = (ev: MessageEvent): void => {
  const receivedData = JSON.parse(ev.data);
  if (receivedData.type == "send") {
    console.log("received send confirmation");
  }  
}
conn.send(sendMsg);

{{< /highlight >}}

and the following to receive messages:

{{< highlight Typescript >}}

const fetchMsg = JSON.stringify({
  type: "fetch",
});

const conn = new WebSocket(`ws://localhost:9001/mix`);
conn.onmessage = (ev: MessageEvent): void => {
  const receivedData = JSON.parse(ev.data);
  if (receivedData.type == "fetch") {
    console.log("fetched the following messages: " + receivedData.messages);
  }  
}
conn.send(fetchMsg);
{{< /highlight >}}

You can see a sample Electron application communicating with the Websocket client [here](../chat-demo).



#### Using TCP Socket

{{% notice warning %}}
Currently usage of TCP socket is heavily discouraged. While theoretically it is working and can provide same functionalities as the websocket we provide absolutely no guarantees regarding API stability or the packet format. It all might change completely without any prior warning. So do not rely on it at this time unless you have no other choice.
{{% /notice %}}

<!-- commented until it works


In an effort to achieve relatively high-level cross-language compatibility, all messages exchanged between socket client and whatever entity is communicating with it, are defined as protobuf messages:

{{< highlight Protobuf >}}
message Request {
    oneof value {
        RequestSendMessage send = 2;
        RequestFetchMessages fetch = 3;
        RequestGetClients clients = 4;
        RequestOwnDetails details = 5;
        RequestFlush flush = 6;
    }
}

// please refer to the current sourcecode for the current content of each request / response

message Response {
    oneof value {
        ResponseException exception = 1;
        ResponseSendMessage send = 2;
        ResponseFetchMessages fetch = 3;
        ResponseGetClients clients = 4;
        ResponseOwnDetails details = 5;
        ResponseFlush flush = 6;
    }
}
{{< /highlight >}}

Currently the socket messages allow for the following:

1. Send arbitrary bytes message to selected recipient
1. Fetch all received messages from the client's buffer
1. Get the list of all possible clients on the network
1. Get `ClientConfig` message describing own Mixnet configuration
1. Force the socket client to flush its writer buffer

Note that when the message is being written into the socket, additional information encoding the length of the message is included. This needs to be handled when reading and writing to the socket.

{{% notice note %}}
Proto-encoded messages are prepended with a 10-byte varint containing the length of the encoding. Please refer to [the sample implementation](https://github.com/nymtech/nym-mixnet/blob/67b5870e4d2665e9555f3c53abca4c4d32601513/client/rpc/utils/utils.go#L29)
{{% /notice %}}

For example, you could start a TCP socket client with `./build/nym-mixnet-client socket --id alice --socket tcp --port 9001`.

To send to oneself, and then fetch received messages using the client's TCP socket, one could do as follows. The example is in Go but the same basic approach should work in every language that speaks TCP:

{{< highlight Go >}}

package main

import (
	"encoding/binary"
	"fmt"
	"github.com/golang/protobuf/proto"
	"io"
	"net"
	"time"

	"github.com/nymtech/nym-mixnet/client/rpc/types"
	"github.com/nymtech/nym-mixnet/client/rpc/utils"
	"github.com/nymtech/nym-mixnet/config"
)

func main() {
	fmt.Println("Send and retrieve through mixnet demo")

	conn, err := net.Dial("tcp", "127.0.0.1:9001")
	if err != nil {
		panic(err)
	}

	myDetails := getOwnDetails(conn)

	fmt.Printf("myDetails: %+v\n\n", myDetails)

	sendMessage("foomp", myDetails, conn)

	fmt.Printf("We sent: %+v\n\n", "foomp")

	time.Sleep(time.Second * 1) // give it some time to send to the mixnet

	messages := fetchMessages(conn)

	fmt.Printf("We got back these bytes: %+v\n\n", messages)
	fmt.Printf("We got back this string: %+v\n\n", string(messages[0]))

}

func getOwnDetails(conn net.Conn) *config.ClientConfig {
	me := &types.Request{
		Value: &types.Request_Details{Details: &types.RequestOwnDetails{}},
	}

	flushRequest := &types.Request{
		Value: &types.Request_Flush{
			Flush: &types.RequestFlush{},
		},
	}

	err := utils.WriteProtoMessage(me, conn)
	if err != nil {
		panic(err)
	}

	err = utils.WriteProtoMessage(flushRequest, conn)
	if err != nil {
		panic(err)
	}

	res := &types.Response{}
	err = utils.ReadProtoMessage(res, conn)
	if err != nil {
		panic(err)
	}

	return res.Value.(*types.Response_Details).Details.Details

}

func sendMessage(msg string, recipient *config.ClientConfig, conn net.Conn) {

	msgBytes := []byte(msg)

	flushRequest := &types.Request{
		Value: &types.Request_Flush{
			Flush: &types.RequestFlush{},
		},
	}

	sendRequest := &types.Request{
		Value: &types.Request_Send{Send: &types.RequestSendMessage{
			Message:   msgBytes,
			Recipient: recipient_address,
		}},
	}

	err := utils.WriteProtoMessage(sendRequest, conn)
	if err != nil {
		panic(err)
	}

	err = utils.WriteProtoMessage(flushRequest, conn)
	if err != nil {
		panic(err)
	}

	res := &types.Response{}
	err = utils.ReadProtoMessage(res, conn)
	if err != nil {
		panic(err)
	}
}

func fetchMessages(conn net.Conn) [][]byte {
	flushRequest := &types.Request{
		Value: &types.Request_Flush{
			Flush: &types.RequestFlush{},
		},
	}

	fetchRequest := &types.Request{
		Value: &types.Request_Fetch{
			Fetch: &types.RequestFetchMessages{},
		},
	}

	err := writeProtoMessage(fetchRequest, conn)
	if err != nil {
		panic(err)
	}

	err = utils.WriteProtoMessage(flushRequest, conn)
	if err != nil {
		panic(err)
	}

	res2 := &types.Response{}
	err = utils.ReadProtoMessage(res2, conn)
	if err != nil {
		panic(err)
	}
	return res2.Value.(*types.Response_Fetch).Fetch.Messages

}

func writeProtoMessage(msg proto.Message, w io.Writer) error {
	b, err := proto.Marshal(msg)
	if err != nil {
		return err
	}

	return encodeByteSlice(w, b)
}

func encodeByteSlice(w io.Writer, bz []byte) (err error) {
	err = encodeBigEndianLen(w, uint64(len(bz)))
	if err != nil {
		return
	}
	_, err = w.Write(bz)
	return
}

func encodeBigEndianLen(w io.Writer, i uint64) (err error) {
	var buf = make([]byte, 8)
	binary.BigEndian.PutUint64(buf, i)
	_, err = w.Write(buf)
	return
}

{{< /highlight >}}


 -->


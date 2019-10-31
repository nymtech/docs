---
title: "Mixnet client"
weight: 30
---

### Clients

{{% notice info %}}
The Nym Client was built in the [Installation](../installation) section. If you haven't yet built the Nym Mixnet and want to run the code on this page, go there first.
{{% /notice %}}

From inside the `nym-mixnet` directory, the `loopix-client` binary got built to the `build` directory, so you can run it by invoking `./build/loopix-client`:

```shell
nym-mixnet$ ./build/loopix-client
Usage: loopix-client COMMAND [OPTIONS]


  _                      _
 | |    ___   ___  _ __ (_)_  __
 | |   / _ \ / _ \| '_ \| \ \/ /
 | |___ (_) | (_) | |_) | |>  <
 |_____\___/ \___/| .__/|_/_/\_\
		  |_|            (client)



Commands:

    init        Initialise a Loopix client
    run         Run a persistent Loopix client process
    socket      Run a background Loopix client listening on a specified socket

Run "loopix-client help <command>" for more info on a specific command.
```

As you can see, there are three commands you can issue to the client.

1. init - initialize a new client instance
1. run - run a loopix client in the foreground
1. socket - run and listen on a socket for real messages as well

Let's try it out. First, you need to initialize a new client.

```
nym-mixnet$ ./build/loopix-client init --id alice
Saved generated private key to /home/you/.loopix/clients/alice/config/private_key.pem
Saved generated public key to /home/you/.loopix/clients/alice/config/public_key.pem
Saved generated config to /home/you/.loopix/clients/alice/config/config.toml
```

Have a look at the generated files if you'd like - they contain client configurations, public/private keypairs, etc.

You can run the client with user `alice` by doing this:

```shell
./build/loopix-client run --id alice
Our Public Key is: z-OQECd8VgC1BeVi6HsHMUbn3REnqZq1uXcyy9j7Hxc=

```

It doesn't look like much happened, it just sits there. But in fact, when you `run()` the client, it immediately starts generating (fake) cover traffic and sending it to the Nym Mixnet.

{{% notice info %}}
Congratulations, you have just contributed a tiny bit of privacy to the world! `<CTRL-C>` to stop the client.
{{% /notice %}}

{{% notice note %}}
If you want to see slightly more detail about what the client is doing, take a look at the log file at `/tmp/loopix_alice.log`. You can change the file by modifying the client's config at `/home/you/.loopix/clients/alice/config/config.toml`. If you change the logging file to an empty value, everything will be printed directly to STDOUT.
{{% /notice %}}

Try stopping and starting the client a few times. If you're interested, you should see your traffic reflected in the network traffic *sent* and *received* metrics at the [Nym Dashboard](https://dashboard.nymtech.net/). Have a look on the right hand side:

![dashboard](/docs/images/dashboard.gif)

### Understanding the client

A large proportion of the Nym Mixnet's functionality is implemented client-side, including:

1. determining network topology
1. registering with mixnet [providers](../providers)
1. fetching stored messages from the [providers](../providers)
1. sending a constant stream of Sphinx packet *cover traffic* messages
1. sending Sphinx packets with real messages
1. sending Sphinx packet *cover traffic* when no real messages are being sent

#### Determining network topology

The first thing to understand is that it's the local client which picks the path that each packet will take through the mixnet topology.

When you first `run` your client, the client needs to figure what mixnodes exist, which layers they're in, and their public keys.

The client asks the Nym directory for the current mixnet topology. The client handles all this automatically, but in order to understand what's happening, you can try it yourself:

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

Upon completing the provider registration, the client starts a separate message stream that periodically fetches all the client's stored messages on the provider. The rate at which this happens is set in the client config files.

{{% notice note %}}
Note that once the message is pulled, currently the provider immediately deletes it from its own storage.
{{% /notice %}}

#### Sending messages

Since it now understands the topology of the mixnet, the client can start sending traffic immediately. But what should it send?

If there's a real message to send (because you called `client.SendMessage()` or poked something down the client's socket connection), then the client will send a real message. Otherwise, the client will send cover traffic, at a rate determined in the client config file in `~/.loopix/clients/<client-id>/config.toml`

Real messages and cover traffic are both encrypted using the Sphinx packet format.

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

Depending on what language you're using, you can fire up the client in one of two ways.

### In Go

If you're a Gopher, you can compile the client code into your own application in the normal Go fashion. This will give you access to all public methods and attributes of the mixnet client. Most notably:

- `client.Start()`
- `client.GetReceivedMessages()`
- `client.SendMessage(message []byte, recipient config.ClientConfig)`

**`client.Start()`**  performs all of the aforementioned required setup, i.e. obtains network topology, registers at a provider, and starts all the traffic streams. In fact just calling `client.Start()` and not doing anything more is equivalent to the `./build/loopix-client run --id alice` command.

{{% notice tip %}}
You can decide at which particular provider should the client register by modifying the `Provider` attribute in the client struct before calling the `.Start()` method.
{{% /notice %}}

When the client fetches valid messages from its provider, they are stored in a local buffer until **`client.GetReceivedMessages()`** is called. This method returns all those messages and resets the buffer.

**`client.SendMessage(message []byte, recipient config.ClientConfig)`** as the name suggests, provides the core functionality of the mixnet by allowing sending arbitrary messages to specified recipients through the Nym Mixnet. It uses the current network topology to generate a path through the mixnet and automatically packs the content into an appropriate Sphinx packet.

The recipient argument is defined as a ClientConfig protobuf message thus allowing for better cross-language compatibility. In the case of the Go implementation, it is compiled down to the language. The protobuf message is defined as follows:

{{< highlight Protobuf >}}
message ClientConfig {
    string Id = 1;
    string Host = 2;
    string Port = 3;
    bytes PubKey = 4;
    MixConfig Provider = 5;
}
{{< /highlight >}}

where

{{< highlight Protobuf >}}
message MixConfig {
    string Id = 1;
    string Host = 2;
    string Port = 3;
    bytes PubKey = 4;
    uint64 Layer = 5;
}
{{< /highlight >}}

{{% notice info %}}
For the client, at this point of time, only the `PubKey` and `Provider` fields are relevant. `Host` and `Port` are no longer used in any meaningful way and will be removed later on. The `Id` equivalent to the encoding of the `PubKey` using the alternate URL base64 encoding as defined in [RFC 4648](https://tools.ietf.org/html/rfc4648). The similar is true for the `MixConfig` for the Provider - the `Id` is the base64 encodin of the public key. However, the `Host` and `Port` fields are actually vital here in order to generate routing information. As for the `Layer`, it is irrelevant in the context of a Provider. It is only required for Mix nodes.

{{% /notice %}}

### In other languages

If you're not a Gopher (go coder), don't despair. You can run the client in socket mode instead, and use either websockets or TCP sockets to get equivalent functionality.

#### Using TCP Socket

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

For example, you could start a TCP socket client with `./build/loopix-client socket --id alice --socket tcp --port 9001`. To fetch received messages using the client's TCP socket, one could do as follows. The example is in Go but the same basic approach should work in every language that speaks TCP:

{{< highlight Go >}}

func WriteProtoMessage(msg proto.Message, w io.Writer) error {
  b, err := proto.Marshal(msg)
  if err != nil {
    return err
  }

  return encodeByteSlice(w, b)
}

func encodeByteSlice(w io.Writer, bz []byte) (err error) {
  err = encodeVarint(w, int64(len(bz)))
  if err != nil {
    return
  }
  _, err = w.Write(bz)
  return
}

func encodeVarint(w io.Writer, i int64) (err error) {
  var buf [10]byte
  n := binary.PutVarint(buf[:], i)
  _, err = w.Write(buf[0:n])
  return
}



[...]



fetchRequest := &types.Request{
  Value: &types.Request_Fetch{
    Fetch: &types.RequestFetchMessages{},
  },
}

flushRequest := &types.Request{
  Value: &types.Request_Flush{
    Flush: &types.RequestFlush{},
  },
}

conn, err := net.Dial("tcp", "127.0.0.1:9001")
if err != nil {
  panic(err)
}

err = utils.WriteProtoMessage(fetchRequest, conn)
if err != nil {
  panic(err)
}

err = utils.WriteProtoMessage(flushRequest, conn)
if err != nil {
  panic(err)
}

// reading response

res := &types.Response{}
err = utils.ReadProtoMessage(res, conn)
if err != nil {
  panic(err)
}

fmt.Printf("%v", res)

{{< /highlight >}}

#### Using the Websocket

Using the websocket is very similar to the way TCP socket is used. In fact it is actually simpler due to HTTP handling few aspects of it for us. For example the encoding of the lengths of messages exchanged or the buffer flushing.

{{% notice note %}}
Note that the websocket will **only** accept requests from the loopback address.
{{% /notice %}}

The identical set of request/responses is available for the Websocket as it was the case with the TCP socket, with the exception of `RequestFlush`, which does not exist. So for example having started the client with: `./build/loopix-client socket --id alice --socket websocket --port 9001`, you could do the following to write a fetch request to a Websocket in Typescript:

{{< highlight Typescript >}}
const fetchMsg = JSON.stringify({
  fetch: {},
});

const conn = new WebSocket(`ws://localhost:9001/mix`);
conn.onmessage = (ev: MessageEvent): void => {
  const fetchData = JSON.parse(ev.data);
  const fetchedMesages = fetchData.fetch.messages;
  console.log(fetchedMessages);
}
conn.send(fetchMsg);
{{< /highlight >}}

You can see a sample Electron application communicating with the Websocket client [here](../chat-demo).

It's also possible to write binary data to the websocket. Here's an example in Go, but the same technique will work in any language that has a `byte` type and supports protobufs:

{{< highlight Go >}}
import (
  "net/url"
  "github.com/golang/protobuf/proto"
  "github.com/gorilla/websocket"
  "github.com/nymtech/nym-mixnet/client/rpc/types"
)

fetchRequest := &types.Request{
  Value: &types.Request_Fetch{
    Fetch: &types.RequestFetchMessages{},
  },
}

u := url.URL{
  Scheme: "ws",
  Host:   "127.0.0.1:9000",
  Path:   "/mix",
}
c, _, err := websocket.DefaultDialer.Dial(u.String(), nil)
if err != nil {
  panic(err)
}

defer c.Close()

fetchRequestBytes, err := proto.Marshal(fetchRequest)
if err != nil {
  panic(err)
}

err = c.WriteMessage(websocket.BinaryMessage, fetchRequestBytes)
if err != nil {
  panic(err)
}

time.Sleep(time.Second)

_, resB, err := c.ReadMessage()
if err != nil {
  panic(err)
}

res := &types.Response{}
err = proto.Unmarshal(resB, res)
if err != nil {
  panic(err)
}

fmt.Printf("%v", res)

{{< /highlight >}}

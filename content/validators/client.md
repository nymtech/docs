---
title: "Validator client"
weight: 55
description: "Similarly to the mixnet client, it is possible to build a standalone client for interacting with the Nym validators. Here's how."

---

### Client

Similarly to the [Mixnet client](../../mixnet/clients), it is possible to build a standalone client for interacting with the Nym validators.

Building the client is rather straightforward. Just type `make build_socket_client` and wait for the magic [not really] to happen. This will place the binary in your $GOPATH and to be precise, it will be `$GOPATH/bin/nym-socket-client`.

In order to run it, assuming your `$GOPATH/bin` is part of your `$PATH`, type `nym-socket-client`. Otherwise run the binary directory from the said directory: `$GOPATH/bin/nym-socket-client`. Invoking it should produce something similar to:

```shell
nym-validator$ nym-socket-client
Usage: nym-socket-client COMMAND [OPTIONS]


  ____                            _        _   _                 
 / ___|___   ___ ___  _ __  _   _| |_     | \ | |_   _ _ __ ___  
| |   / _ \ / __/ _ \| '_ \| | | | __|____|  \| | | | | '_ \ _ \
| |___ (_) | (__ (_) | | | | |_| | |______| |\  | |_| | | | | | |
 \____\___/ \___\___/|_| |_|\__,_|\__|    |_| \_|\__, |_| |_| |_|
             (nym-socket-client)                 |___/           



Commands:

    socket      Run a nym socket client

Run "nym-socket-client help <command>" for more info on a specific command.

```

As you can see, there is currently only a single command you can issue to the client.

1. socket - run and listen on a socket for any relevant requests.

It, however, takes few mandatory parameters. Those are:

1. `--f` must point to a valid configuration file, such as one of the configs included in `nym-validator/client/sample_configs/` directory. Note that the configuration itself specifies path to the Ethereum Ropsten network private key. Make sure it is correct.
1. `--socket` specifies whether the client should listen on a tcp socket or a websocket. Allowable values are `tcp` or `websocket`.
1. `--port` port on which the client is going to be listening

{{% notice info %}}
The sample configuration files in `nym-validator/client/sample_configs/` are actually identical to the ones bundled with the [Qt Client Demo](../client-demo).
{{% /notice %}}

## Integrating the validator client in your applications

Depending on what language you're using, you can fire up the client in one of two ways.

### In Go

If you're a Gopher, you can compile the client code into your own application in the normal Go fashion. This will give you access to all public methods and attributes of the validator client. Most notably:

- `client.RegisterAccount()`
- `client.GetCredential()`
- `client.ForceReRandomizeCredential()`
- `client.SpendCredential()`

**`client.RegisterAccount()`** in essence sends a "Hi I want to participate in Nym" transaction to the Tendermint chain allowing you to send subsequent requests to get credentials.

**`client.GetCredential()`** allows client to send the request to obtain a Nym credential of some specified value. It obtains responses from a threshold number of validators. Those partial credentials are then aggregated and explicitly randomised.

{{% notice info %}}
In order for `client.GetCredential()` to succeed, you must ensure you have sent appropriate amount of [as of time of writing] Ropsten network Ethereum to the Nym pipe account [defined in the config files]
{{% /notice %}}

While `client.GetCredential()` has rerandomized the credential making it indistinguishable from the aggregated partial credentials, you might want to explicitly do it again to feel safer. **`client.ForceReRandomizeCredential()`** lets you do exactly that.

Finally **`client.SpendCredential()`** allows you to spend one of your credentials at some service provider. Right now the available services providers are written in the configuration file, however, an option to get them from the directory server is going to be added in near future.

### In other languages

If you're not a Gopher (go coder), don't despair. You can run the client in socket mode instead, and use either websockets or TCP sockets to get equivalent functionality.

#### Using TCP Socket

In an effort to achieve relatively high-level cross-language compatibility, all messages exchanged between socket client and whatever entity is communicating with it, are defined as protobuf messages:

{{< highlight Protobuf >}}
message Request {
    oneof value {
        RequestGetCredential getCredential = 2;
        RequestSpendCredential spendCredential = 3;
        RequestGetServiceProviders getProviders = 4;
        RequestRerandomize rerandomize = 5;
        RequestFlush flush = 6;
    }
}

// please refer to the current sourcecode for the current content of each request / response

message Response {
    oneof value {
        ResponseException exception = 1;
        ResponseGetCredential getCredential = 2;
        ResponseSpendCredential spendCredential = 3;
        ResponseGetServiceProviders getProviders = 4;
        ResponseRerandomize rerandomize = 5;
        ResponseFlush flush = 6;
    }
}
{{< /highlight >}}

Currently the socket messages allow for the following:

1. Obtain credential for some specified value
1. Rerandomize credential any number of times
1. Spend the credential at some specified service provider
1. Obtain list of all available service providers on the network
1. Force the socket client to flush its writer buffer

Note that when the message is being written into the socket, additional information encoding the length of the message is included. This needs to be handled when reading and writing to the socket.

{{% notice note %}}
Proto-encoded messages are prepended with a 10-byte varint containing the length of the encoding. Please refer to [the sample implementation](https://github.com/nymtech/nym-validator/blob/0d6edbbd3c10b3fa5ef4b6907814c56c29f582f0/client/rpc/utils/utils.go#L29)
{{% /notice %}}

For example, you could start a TCP socket client with `nym-socket-client --f client/sample_configs/testnet_config.toml
 --socket tcp --port 9001`. To obtain credential with value `1` using the client's TCP socket, one could do as follows. The example is in Go but the same basic approach should work in every language that speaks TCP:


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



getCredRequest := &types.Request{
  Value: &types.Request_GetCredential{
    GetCredential: &types.RequestGetCredential{
      Value: 1,
    },
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

err = utils.WriteProtoMessage(getCredRequest, conn)
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

The identical set of request/responses is available for the Websocket as it was the case with the TCP socket, with the exception of `RequestFlush`, which does not exist. So for example having started the client with: `nym-socket-client --f client/sample_configs/testnet_config.toml --socket websocket --port 9001`, you could do the following to write a get credential request to a Websocket in Typescript:

{{< highlight Typescript >}}
const getCredMsg = JSON.stringify({
  getCredential: {
    value: 1,
  },
});

const conn = new WebSocket(`ws://localhost:9001/coco`);
conn.onmessage = (ev: MessageEvent): void => {
  const getCredentialData = JSON.parse(ev.data);
  const credential = getCredentialData.getCredential.credential;
  console.log(credential);
}
conn.send(getCredMsg);
{{< /highlight >}}

It's also possible to write binary data to the websocket. Here's an example in Go, but the same technique will work in any language that has a `byte` type and supports protobufs:

{{< highlight Go >}}
import (
  "net/url"
  "github.com/golang/protobuf/proto"
  "github.com/gorilla/websocket"
  types "github.com/nymtech/nym-validator/client/rpc/clienttypes"
)

getCredRequest := &types.Request{
  Value: &types.Request_GetCredential{
    GetCredential: &types.RequestGetCredential{
      Value: 1,
    },
  },
}

u := url.URL{
  Scheme: "ws",
  Host:   "127.0.0.1:9000",
  Path:   "/coco",
}
c, _, err := websocket.DefaultDialer.Dial(u.String(), nil)
if err != nil {
  panic(err)
}

defer c.Close()

getCredRequestBytes, err := proto.Marshal(getCredRequest)
if err != nil {
  panic(err)
}

err = c.WriteMessage(websocket.BinaryMessage, getCredRequestBytes)
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

{{% notice tip %}}
More examples for using the socket (both TCP and Websocket) in Go are shown in `nym-validator/client/rpc/client/main.go`
{{% /notice %}}

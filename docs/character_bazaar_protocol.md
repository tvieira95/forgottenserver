# Character Bazaar binary protocol

The Bazaar does not use Extended Opcode, opcode 207, Lua authority, or JSON.
The server is the authority for every requirement, coin movement, and auction
state change.

## Packet identifiers

| Direction | Packet | Meaning |
| --- | --- | --- |
| AstraClient -> TFS | `0x5E` | Character Bazaar request |
| TFS -> AstraClient | `0x2E` | Character Bazaar response |

`0x5E` is unused in the client-to-server 8.60 protocol used by this project.
`0x2E` is unused in the Astra server-to-client custom range.

## Client -> server

Both packets start with `0x5E` followed by an action byte.

### Request requirements

| Type | Value |
| --- | --- |
| `u8` | `0x5E` packet |
| `u8` | `0x01` request requirements |

### Create auction

| Type | Value |
| --- | --- |
| `u8` | `0x5E` packet |
| `u8` | `0x02` create auction |
| `u32` | starting price |
| `u32` | duration in seconds |
| Tibia string (`u16` length + bytes) | description, maximum 512 bytes |

## Server -> client

Both packets start with `0x2E` followed by an action byte.

### Requirements response

| Type | Value |
| --- | --- |
| `u8` | `0x2E` packet |
| `u8` | `0x01` requirements response |
| `u8` | can auction (`0` or `1`) |
| `u32` | minimum level |
| `u32` | minimum price |
| `u32` | minimum duration in seconds |
| `u32` | maximum duration in seconds |
| `u32` | creation fee |
| `u8` | commission percent |
| `u32` | transferable Tibia Coin balance |
| Tibia string | blocking reason, empty when allowed |

### Create result

| Type | Value |
| --- | --- |
| `u8` | `0x2E` packet |
| `u8` | `0x02` create result |
| `u8` | success (`0` or `1`) |
| Tibia string | server result message |

The client never treats a local click as a successful auction. It only closes
the window after receiving a successful `0x02` response.

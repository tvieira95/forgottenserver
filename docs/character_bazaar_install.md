# Character Bazaar installation

## Database

TFS migration `data/migrations/55.lua` creates the shared Bazaar tables:

- `character_auctions`
- `character_auction_bids`
- `character_auction_history`

MyAAC migration `system/migrations/47.php` creates the same tables
idempotently, so either deployment order is safe. Run the usual migration for
both applications before enabling live traffic.

The existing project currency was detected as `accounts.tibia_coins`. Bazaar
uses this field as its transferable Tibia Coin balance. Do not substitute
`premium_points`, `coins`, or an invented column.

## Server configuration

`config.lua.dist` documents these optional settings (the C++ defaults match
these values when an existing local `config.lua` does not define them):

```lua
characterBazaarEnabled = true -- explicit opt-in; the server defaults to false
characterBazaarMinLevel = 50
characterBazaarMinPrice = 100
characterBazaarAuctionFee = 50
characterBazaarCommissionPercent = 10
characterBazaarMinDurationHours = 24
characterBazaarMaxDurationDays = 7
```

Rebuild TFS after applying the source changes. At startup, TFS immediately
finishes overdue auctions and schedules subsequent finalization every minute.

## AstraClient

Build AstraClient after updating `src/client`. The new `game_character_bazaar`
module is autoloaded and adds a Character Bazaar button to the in-game main
panel. It communicates only through the binary protocol documented in
`character_bazaar_protocol.md`.

## MyAAC

Run migration 47 (or normal automatic migration). The Character Bazaar menu is
added to the Shop category in the bundled `tibiacom` and `kathrine` templates.
The page is `character-bazaar` and accepts bids with CSRF protection, row locks,
and an SQL transaction.

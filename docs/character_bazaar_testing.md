# Character Bazaar test checklist

1. Run TFS migration 55 and MyAAC migration 47; verify all three Bazaar tables.
2. Start TFS and verify normal accounts still receive their full character list.
3. Open Character Bazaar in AstraClient; verify the server returns requirements.
4. Verify that a low-level character, staff character, guild member, house owner,
   market seller, player outside PZ, PZ-locked player, and player without enough
   `tibia_coins` are rejected by the server.
5. Create a valid auction and verify the fee is debited exactly once, the history
   has a `created` entry, and the character is force-kicked.
6. Confirm the listed character is absent from the login character list and a
   direct login attempt receives the Bazaar blocking message.
7. Open MyAAC `character-bazaar`; verify the active auction and snapshot fields.
8. Place a bid from a different account. Verify that balance is debited, a bid
   row and `bid` history row exist, and the active bid changes atomically.
9. Outbid the first account and verify its previous full bid is immediately
   refunded exactly once.
10. Verify the seller cannot bid on their own auction and expired auctions reject
    bids even before the next scheduler minute.
11. Set an auction end time in the past (test database only) and wait one minute.
    With a bidder, verify player account transfer, seller payout after commission,
    `finished` status/history, and character login visibility for the winner.
12. Repeat without a bidder. Verify `cancelled` status and `expired_no_bid`
    history, with character ownership unchanged.
13. Re-run finalization and verify neither payout nor transfer is duplicated.

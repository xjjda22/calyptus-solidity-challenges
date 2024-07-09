# Solidity Challenge #383 🕵️‍♂️

Would you deploy this Auction contract? 👀
![Auction Contract](383.jpeg)

## Problem Explanation

Imagine an auction where people bid. The highest bidder wins. Others get their money back. Here's the process:

1. **Bidding**: 
   - People send money to bid.
   - The highest bid wins.
2. **Withdraw**: 
   - Outbid people can withdraw their money.
3. **End Auction**: 
   - The highest bid goes to the auction owner.

## What Went Wrong?

The withdraw function has a re-entrancy bug. Here's an example:

### Example:
1. Alice bids 1 ether.
2. Bob bids 2 ether.
3. Alice withdraws her 1 ether.

- If Alice's withdrawal goes to her smart contract, it could be malicious. It could call `withdraw` again before the first call finishes.
- Alice's contract could keep asking for money back before the system realizes she was refunded.

### Solution

To prevent this, update the state before transferring money. This ensures withdrawals are marked as done before sending money.

1. Update the state to mark the withdrawal.
2. Transfer the money after updating the state.
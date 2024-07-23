# Solidity Challenge #374 🕵️‍♂️
Find the vulnerability in the DigitalWallet contract that prevents accurate wallet balance updates ♻️
![DigitalWallet Contract](374.jpeg)

### What Went Wrong?
1. The updateWalletBalance function uses the memory keyword.
2. This creates a temporary copy instead of updating the actual wallet balance in storage.

### Example
1. When updateWalletBalance is called, the wallet balance does not change.
2. The changes are made to a temporary copy in memory, not the original storage.

### Solution
1. Use the storage keyword to update the actual wallet balance.
2. This ensures changes are saved to the blockchain.
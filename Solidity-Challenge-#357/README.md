# Solidity Challenge #374 🕵️‍♂️

Find the vulnerability in the DigitalWallet contract that could prevent users from accurately updating their wallet balances ♻️
![DigitalWallet Contract](374.jpeg)

### What Went Wrong?
The issue lies in the updateWalletBalance function where the wallet data is being accessed and modified. The wallet data should be updated in storage, but the code is using the memory keyword, which only creates a copy in memory and does not persist changes to the blockchain state.

### Example
When calling updateWalletBalance, the balance of the wallet will not be updated because the changes are made to a copy in memory rather than the original storage.

### Solution
To fix this, the wallet data should be accessed using the storage keyword to ensure changes persist.
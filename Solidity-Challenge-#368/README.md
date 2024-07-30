# Solidity Challenge #369 🕵️‍♂️
Can the 'spin' function in this RouletteSpin contract be exploited to always win? 🎲

![RouletteSpin Contract](368.jpeg)

### Issues
1. Fixed Bet: Requires exactly 10 ether to play.
2. Timestamp Manipulation: Miners can manipulate block timestamps.
3. Single Spin: Only one spin per block.

### Example
1. Send 10 ether.
2. If block timestamp % 15 == 0, win the contract balance.

### Solutions
1. Flexible Betting: Allow different bet amounts.
2. Secure Randomness: Use a secure randomness source.
3. Multiple Spins: Allow multiple spins per block.
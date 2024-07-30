// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RouletteSpin {
    uint public lastSpinTime;  // Timestamp of the last spin

    constructor() payable {}

    // Function to participate in the Roulette spin by sending 10 ether
    function spin() external payable {
        require(
            msg.value == 10 ether,
            "You must send exactly 10 ether to play"
        );  // Must send 10 ether to play
        require(
            block.timestamp != lastSpinTime,
            "Only one transaction allowed per block"
        );  // Only one spin per block

        lastSpinTime = block.timestamp;  // Record the timestamp of the last spin

        // If the current timestamp is divisible by 15, the player wins the entire balance of the contract
        if (block.timestamp % 15 == 0) {
            (bool sent, ) = msg.sender.call{value: address(this).balance}("");
            require(sent, "Failed to send Ether");
        }
    }

    // Function to get the balance of the contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

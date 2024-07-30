// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RouletteSpinFix {
    uint public lastSpinTime;

    constructor() payable {}

    function spin() external payable {
        require(msg.value == 10 ether, "You must send exactly 10 ether to play");
        require(block.timestamp != lastSpinTime, "Only one transaction allowed per block");

        lastSpinTime = block.timestamp;

        if (block.timestamp % 15 == 0) {
            (bool sent, ) = msg.sender.call{value: address(this).balance}("");
            require(sent, "Failed to send Ether");
        }
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

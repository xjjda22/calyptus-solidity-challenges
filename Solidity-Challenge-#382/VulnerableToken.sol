// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract VulnerableToken {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public lockTime;

    constructor() {
        balances[msg.sender] = 1000; // Initial supply
    }

    function lockToken(uint256 _time) public {
        lockTime[msg.sender] = block.timestamp + _time;
    }

    function unlockToken() public {
        lockTime[msg.sender] = 0;
    }
}

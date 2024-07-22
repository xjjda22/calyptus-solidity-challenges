// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ShortCircuit {
    mapping(address => uint256) public balanceOf;

    function deposit(uint256 amount) external {
        balanceOf[msg.sender] += amount;
    }

    function costlyCheck(address user) internal view returns (bool) {
        uint256 sum = 0;
        for (uint i = 0; i < balanceOf[user]; i++) {
            sum += i;
        }
        return sum % 2 == 0; // This is just a random condition
    }

    function withdraw1(uint256 amount) external {
        require(amount > 0 && costlyCheck(msg.sender), 'Invalid amount or failed costly check');
        balanceOf[msg.sender] -= amount;
        // logic to send the withdrawn amount to the user...
    }

    function withdraw2(uint256 amount) external {
        require(costlyCheck(msg.sender) && amount > 0, 'Invalid amount or failed costly check');
        balanceOf[msg.sender] -= amount;
        // logic to send the withdrawn amount to the user...
    }
}

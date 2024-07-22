// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Challenge {
    mapping(address => uint256) public stakes;
    address[] public stakers;
    uint256 public totalStakes;
    uint256 public endTime;

    constructor(uint256 duration) {
        endTime = block.timestamp + duration;
    }

    function stake() external payable {
        require(block.timestamp < endTime, "Staking period has ended");
        require(msg.value > 0, "Must stake a positive amount");

        if (stakes[msg.sender] == 0) {
            stakers.push(msg.sender);
        }

        stakes[msg.sender] += msg.value;
        totalStakes += msg.value;
    }

    function claimReward() external {
        require(block.timestamp > endTime, "Claiming period has not started yet");

        uint256 userStake = stakes[msg.sender];
        require(userStake > 0, "No stakes to claim rewards for");

        uint256 reward = (userStake * address(this).balance) / totalStakes;

        stakes[msg.sender] = 0;
        payable(msg.sender).transfer(reward);
    }
    
    receive() external payable {}
}

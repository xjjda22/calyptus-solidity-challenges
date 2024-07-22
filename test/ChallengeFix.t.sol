// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/ChallengeFix.sol";

contract ChallengeFixTest is Test {
    ChallengeFix public challengeFix;

    function setUp() public {
        challengeFix = new ChallengeFix(60); // Staking period of 60 seconds
    }

    function testStake() public {
        address addr1 = address(0x123);
        vm.deal(addr1, 1 ether);
        vm.prank(addr1);
        challengeFix.stake{value: 1 ether}();
        assertEq(challengeFix.stakes(addr1), 1 ether);
    }

    function testClaimReward() public {
        address addr1 = address(0x123);
        vm.deal(addr1, 1 ether);
        vm.prank(addr1);
        challengeFix.stake{value: 1 ether}();
        vm.warp(block.timestamp + 61); // Increase time to after staking period

        uint256 initialBalance = addr1.balance;
        vm.prank(addr1);
        challengeFix.claimReward();
        uint256 finalBalance = addr1.balance;

        assert(finalBalance > initialBalance);
    }
}

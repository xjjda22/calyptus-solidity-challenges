// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/RouletteSpinFix.sol";

contract RouletteSpinFixTest is Test {
    RouletteSpinFix public rouletteSpin;

    function setUp() public {
        rouletteSpin = new RouletteSpinFix();
        vm.deal(address(this), 100 ether);
    }

    function testSpinWin() public {
        uint256 balanceBefore = address(this).balance;
        rouletteSpin.spin{value: 10 ether}();
        uint256 balanceAfter = address(this).balance;
        assert(balanceAfter > balanceBefore);
    }
}

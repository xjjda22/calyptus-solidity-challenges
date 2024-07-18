// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/ShortCircuitFix.sol";

contract ShortCircuitFixTest is Test {
    ShortCircuitFix public shortCircuitFix;
    address public addr1;

    function setUp() public {
        shortCircuitFix = new ShortCircuitFix();
        addr1 = address(0x1234);
    }

    function testDeposit() public {
        vm.prank(addr1);
        shortCircuitFix.deposit(1000);
        assertEq(shortCircuitFix.balanceOf(addr1), 1000);
    }

    function testWithdraw() public {
        vm.prank(addr1);
        shortCircuitFix.deposit(1000);

        vm.prank(addr1);
        shortCircuitFix.withdraw(500);
        assertEq(shortCircuitFix.balanceOf(addr1), 500);
    }

    function testWithdrawFailZeroAmount() public {
        vm.prank(addr1);
        shortCircuitFix.deposit(1000);

        vm.prank(addr1);
        vm.expectRevert("Invalid amount");
        shortCircuitFix.withdraw(0);
    }

    function testWithdrawFailCostlyCheck() public {
        vm.prank(addr1);
        shortCircuitFix.deposit(3);

        vm.prank(addr1);
        vm.expectRevert("Failed costly check");
        shortCircuitFix.withdraw(1);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import '../contracts/DigitalWalletFix.sol';

contract DigitalWalletFixTest is Test {
    DigitalWalletFix public digitalWalletFix;
    address owner;
    address addr1;

    function setUp() public {
        owner = address(this);
        addr1 = address(0x123);
        digitalWalletFix = new DigitalWalletFix();
    }

    function testInitialWallet() public {
        (uint256 id, uint256 balance) = digitalWalletFix.wallets(owner);
        assertEq(id, 1);
        assertEq(balance, 100);
    }

    function testUpdateWalletBalance() public {
        digitalWalletFix.updateWalletBalance(owner, 200);
        (, uint256 balance) = digitalWalletFix.wallets(owner);
        assertEq(balance, 200);
    }

    function testUnauthorizedUpdate() public {
        vm.prank(addr1);
        vm.expectRevert('Unauthorized update');
        digitalWalletFix.updateWalletBalance(owner, 200);
    }

    function testInvalidWalletAddress() public {
        vm.expectRevert('Invalid wallet address');
        digitalWalletFix.updateWalletBalance(address(0), 200);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/GiftCardDistributorFix.sol";

contract GiftCardDistributorFixTest is Test {
    GiftCardDistributorFix distributor;
    address owner;
    address addr1 = address(0x1);
    address addr2 = address(0x2);

    function setUp() public {
        owner = address(this);
        distributor = new GiftCardDistributorFix();
    }

    function testPurchaseGiftCards() public {
        vm.prank(addr1);
        distributor.purchaseGiftCards{value: 1 ether}();
        uint256 balance = distributor.giftCardBalances(addr1);
        assertEq(balance, 1 ether);
    }

    // function testDistributeGiftCardsAsOwner() public {
    //     distributor.purchaseGiftCards{value: 2 ether}();
    //     address;
    //     recipients[0] = addr1;
    //     recipients[1] = addr2;

    //     uint256;
    //     amounts[0] = 0.5 ether;
    //     amounts[1] = 0.5 ether;

    //     distributor.distributeGiftCards(recipients, amounts);

    //     assertEq(distributor.giftCardBalances(owner), 1 ether);
    // }

    // function testFailDistributeGiftCardsNotOwner() public {
    //     vm.prank(addr1);
    //     address;
    //     recipients[0] = addr1;

    //     uint256;
    //     amounts[0] = 0.5 ether;

    //     distributor.distributeGiftCards(recipients, amounts);
    // }

    // function testFailDistributeGiftCardsMismatchLength() public {
    //     distributor.purchaseGiftCards{value: 2 ether}();
    //     address;
    //     recipients[0] = addr1;

    //     uint256;
    //     amounts[0] = 0.5 ether;
    //     amounts[1] = 0.5 ether;

    //     distributor.distributeGiftCards(recipients, amounts);
    // }

    // function testFailInsufficientGiftCardBalance() public {
    //     distributor.purchaseGiftCards{value: 1 ether}();
    //     address;
    //     recipients[0] = addr1;
    //     recipients[1] = addr2;

    //     uint256;
    //     amounts[0] = 0.5 ether;
    //     amounts[1] = 0.6 ether;

    //     distributor.distributeGiftCards(recipients, amounts);
    // }
}

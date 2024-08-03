// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import '../contracts/TicketingSystemFix.sol';

contract TicketingSystemFixTest is Test {
    TicketingSystemFix public ticketingSystem;
    address addr1 = address(0x1);

    function setUp() public {
        ticketingSystem = new TicketingSystemFix();

        // Setup some initial data
        ticketingSystem.setTicketDetails(1, 10, 0.1 ether); // ticketId 1
        ticketingSystem.setTicketDetails(2, 20, 0.2 ether); // ticketId 2
    }

    function testBuyTickets() public {
        uint256[] memory ids = new uint256[](2);
        ids[0] = 1;
        ids[1] = 2;

        uint256[] memory quantities = new uint256[](2);
        quantities[0] = 2; // ticketId 1
        quantities[1] = 3; // ticketId 2

        // Calculate total price = 0.1*2 + 0.2*3 = 0.8 ether
        vm.deal(addr1, 1 ether);
        vm.prank(addr1);
        ticketingSystem.buyTicketsBatch{ value: 0.8 ether }(addr1, ids, quantities);

        assertEq(ticketingSystem.totalSupply(1), 2);
        assertEq(ticketingSystem.totalSupply(2), 3);
    }

    function testMaxSupplyReached() public {
        ticketingSystem.setTicketDetails(1, 2, 0.1 ether); // set max supply for ticketId 1 to 2

        uint256[] memory ids = new uint256[](2);
        ids[0] = 1;
        ids[1] = 1;

        uint256[] memory quantities = new uint256[](2);
        quantities[0] = 1;
        quantities[1] = 2;

        // Calculate total quantity = 3 > max supply
        vm.deal(addr1, 1 ether);
        vm.prank(addr1);
        vm.expectRevert('MaxSupplyReached');
        ticketingSystem.buyTicketsBatch{ value: 0.3 ether }(addr1, ids, quantities);
    }

    function testInvalidPrice() public {
        uint256[] memory ids = new uint256[](2);
        ids[0] = 1;
        ids[1] = 2;

        uint256[] memory quantities = new uint256[](2);
        quantities[0] = 1;
        quantities[1] = 1;

        // Calculate total price = 0.1*1 + 0.2*1 = 0.3 ether
        vm.deal(addr1, 1 ether);
        vm.prank(addr1);
        vm.expectRevert('InvalidPrice');
        ticketingSystem.buyTicketsBatch{ value: 0.2 ether }(addr1, ids, quantities);
    }
}

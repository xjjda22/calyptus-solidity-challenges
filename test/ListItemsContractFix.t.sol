// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import '../contracts/ListItemsContractFix.sol';

contract ListItemsContractFixTest is Test {
    ListItemsContractFix public listItems;

    function setUp() public {
        listItems = new ListItemsContractFix();
    }

    function testAddItem() public {
        listItems.addItem('Item 1');
        (uint256 id, string memory name) = listItems.items(0);
        assertEq(name, 'Item 1');
    }

    function testDeleteItem() public {
        listItems.addItem('Item 1');
        listItems.addItem('Item 2');
        listItems.deleteItem(0);
        (uint256 id, string memory name) = listItems.items(0);
        assertEq(name, 'Item 2');
    }
}

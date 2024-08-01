// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ListItemsContractFix {
    struct Item {
        uint256 id;
        string name;
    }

    Item[] public items;

    event ItemDeleted(uint256 indexed itemId);

    function addItem(string memory name) public {
        uint256 itemId = items.length;
        items.push(Item(itemId, name));
    }

    function deleteItem(uint256 itemId) public {
        require(itemId < items.length, 'Invalid item ID');

        uint256 lastIndex = items.length - 1;
        Item memory lastItem = items[lastIndex];

        // Replace the item to delete with the last item in the list and update its ID
        items[itemId] = lastItem;
        items[itemId].id = itemId;

        // Remove the last item
        items.pop();

        emit ItemDeleted(itemId);
    }
}

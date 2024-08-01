// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ListItemsContract {
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

        // Replace the item to delete with the last item in the list
        Item storage lastItem = items[items.length - 1];
        Item storage itemToDelete = items[itemId];
        itemToDelete = lastItem;

        items.pop();

        emit ItemDeleted(itemId);
    }
}

# Solidity Challenge #372 🕵️‍♂️
This contract enables adding and deleting items from a list, but it has an issue. 

![ListItems Contract](372.jpeg)

### What Went Wrong?
1. Data Overwriting: The deleteItem function attempts to overwrite the deleted item with the last item, but it does not properly update the item ID of the moved item.
2. Event Emission: The ItemDeleted event emits the itemId of the originally intended deletion, not the actual item ID of the deleted item after shifting.
3.Missing Items Tracking: The contract does not correctly handle the removal of items, leading to potential data inconsistencies.

### Example
If an item with ID 1 is deleted, and there are items with IDs 0, 1, 2, and 3 in the list, the last item (ID 3) is moved to index 1. However, the item's ID remains 3, causing a discrepancy in the stored data.

### Solution
1. Correct Data Overwriting: Properly update the ID of the last item when moving it.
2. Correct Event Emission: Emit the correct item ID after the deletion.
3. Consistent State Maintenance: Ensure the array reflects consistent state after deletions.
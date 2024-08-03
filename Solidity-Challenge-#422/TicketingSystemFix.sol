// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC1155/ERC1155.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol';

contract TicketingSystemFix is ERC1155, Ownable, ERC1155Supply {
    constructor() ERC1155('') {}

    error MaxSupplyReached();
    error InvalidPrice();

    mapping(uint256 => uint256) public ticketsWithMaxSupply;
    mapping(uint256 => uint256) public ticketsWithPrice;

    function setTicketDetails(uint256 ticketId, uint256 maxSupply, uint256 price) external onlyOwner {
        ticketsWithMaxSupply[ticketId] = maxSupply;
        ticketsWithPrice[ticketId] = price;
    }

    function buyTicketsBatch(address to, uint256[] calldata ids, uint256[] calldata quantities) external payable {
        uint256 overallPrice;

        for (uint256 i = 0; i < ids.length; ++i) {
            uint256 ticketQuantity = quantities[i];
            uint256 ticketId = ids[i];

            overallPrice += ticketsWithPrice[ticketId] * ticketQuantity;

            if (ERC1155Supply.totalSupply(ticketId) + ticketQuantity > ticketsWithMaxSupply[ticketId]) {
                revert MaxSupplyReached();
            }
        }
        if (msg.value != overallPrice) revert InvalidPrice();

        _mintBatch(to, ids, quantities, '');
    }

    // Overrides required by Solidity.
    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal override(ERC1155, ERC1155Supply) {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}

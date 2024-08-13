// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GiftCardDistributorFix {
    address public marketplaceOwner;
    mapping(address => uint256) public giftCardBalances;

    // Custom Errors
    error NotMarketplaceOwner();
    error InsufficientGiftCardBalance();
    error InvalidInput();

    constructor() {
        marketplaceOwner = msg.sender;
    }

    modifier onlyMarketplaceOwner() {
        if (msg.sender != marketplaceOwner) revert NotMarketplaceOwner();
        _;
    }

    function purchaseGiftCards() external payable {
        giftCardBalances[msg.sender] += msg.value;
    }

    function distributeGiftCards(address[] memory recipients, uint256[] memory amounts) external onlyMarketplaceOwner {
        if (recipients.length != amounts.length) revert InvalidInput();

        uint256 totalDistribution = 0;
        for (uint i = 0; i < amounts.length; i++) {
            totalDistribution += amounts[i];
        }

        if (giftCardBalances[marketplaceOwner] < totalDistribution) revert InsufficientGiftCardBalance();

        for (uint i = 0; i < recipients.length; i++) {
            (bool success, ) = payable(recipients[i]).call{value: amounts[i]}("");
            require(success, "Transfer failed");
            giftCardBalances[marketplaceOwner] -= amounts[i];
        }
    }
}

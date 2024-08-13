// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GiftCardDistributor {
    address public marketplaceOwner;
    mapping(address => uint256) public giftCardBalances;

    // Custom Errors
    error NotMarketplaceOwner();
    error InsufficientGiftCardBalance();

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
        uint256 totalDistribution = 0;
        for (uint i = 0; i < recipients.length; i++) {
            totalDistribution += amounts[i];
        }

        if (giftCardBalances[marketplaceOwner] < totalDistribution) revert InsufficientGiftCardBalance();

        for (uint i = 0; i < recipients.length; i++) {
            payable(recipients[i]).transfer(amounts[i]);
            giftCardBalances[marketplaceOwner] -= amounts[i];
        }
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract SimpleAuctionFix {
    address public beneficiary;
    uint256 public auctionEndTime;

    address public highestBidder;
    uint256 public highestBid;

    mapping(address => uint256) pendingReturns;

    bool ended;

    event HighestBidIncreased(address bidder, uint256 amount);
    event AuctionEnded(address winner, uint256 amount);

    error AuctionAlreadyEnded();
    error BidNotHighEnough(uint256 currentHighestBid);
    error AuctionNotYetEnded();
    error AuctionEndAlreadyCalled();

    constructor(uint256 _biddingTime, address _beneficiary) {
        beneficiary = _beneficiary;
        auctionEndTime = block.timestamp + _biddingTime;
    }

    function bid() external payable {
        if (block.timestamp > auctionEndTime) revert AuctionAlreadyEnded();
        if (msg.value <= highestBid) revert BidNotHighEnough(highestBid);

        if (highestBidder != address(0)) {
            pendingReturns[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
        emit HighestBidIncreased(msg.sender, msg.value);
    }

    function withdraw() external returns (bool) {
        uint256 amount = pendingReturns[msg.sender];
        if (amount > 0) {
            // Step 1: Mark the withdrawal as done before sending money
            pendingReturns[msg.sender] = 0;

            // Step 2: Send the money
            (bool success, ) = payable(msg.sender).call{ value: amount }('');
            if (!success) {
                // If sending money fails, revert the withdrawal state
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }

    function auctionEnd() external {
        if (block.timestamp < auctionEndTime) revert AuctionNotYetEnded();
        if (ended) revert AuctionEndAlreadyCalled();

        ended = true;
        emit AuctionEnded(highestBidder, highestBid);

        payable(beneficiary).transfer(highestBid);
    }
}

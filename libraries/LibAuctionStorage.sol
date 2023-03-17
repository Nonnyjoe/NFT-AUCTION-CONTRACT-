// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

library LibAuctionStorage {
    struct Bid {
        bytes32 blindedBid;
        uint256 deposit;
    }

    struct NFT {
        address nftAddress;
        uint256 nftID;
        uint256 initialPrice;
    }

    struct AuctionStorage {
        uint256[] voteId;
        mapping(uint256 => bool) idUsed;
        mapping(uint256 => NFT) auctionNFT;
        mapping(uint256 => address payable) beneficiary;
        mapping(uint256 => bool) ended;
        mapping(uint256 => uint256) biddingEnd;
        mapping(uint256 => uint256) revealEnd;
        mapping(uint256 => uint256) highestBid;
        mapping(uint256 => address) highestBidder;
        mapping(uint256 => mapping(address => bytes4)) bids;
        mapping(uint256 => mapping(address => uint)) pendingReturns;
    }
}

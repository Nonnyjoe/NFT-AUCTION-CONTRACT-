// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "./LibAuctionFunctions.sol";

contract BlindAuction is LibAuctionFunctions {
    constructor() {
        Moderator = msg.sender;
    }

    function createAuction(
        uint voteId,
        uint biddingTime,
        uint revealTime,
        address nftAddress,
        uint nftId,
        uint _price
    ) external {
        _createAuction(
            voteId,
            biddingTime,
            revealTime,
            nftAddress,
            nftId,
            _price
        );
    }

    function placeHiddenBid(
        uint256 _voteId
    ) external payable onlyBefore(ds.biddingEnd[_voteId]) isValidID(_voteId) {
        _placeHiddenBid(_voteId);
    }

    function withdraw(uint256 _voteId) external isValidID(_voteId) {
        _withdraw(_voteId);
    }

    function auctionEnd(
        uint256 _voteId
    ) external onlyAfter(ds.revealEnd[_voteId]) isValidID(_voteId) {
        _auctionEnd(_voteId);
    }

    function revealBid(
        uint256 _voteId,
        uint256 _bidAmmount
    )
        external
        onlyAfter(ds.biddingEnd[_voteId])
        onlyBefore(ds.revealEnd[_voteId])
        isValidID(_voteId)
    {
        _revealBid(_voteId, _bidAmmount);
    }

    function AdminWithdrawal() public {
        _AdminWithdrawal();
    }

    receive() external payable {}

    fallback() external payable {}
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "lib/forge-std/src/Test.sol";
import "lib/forge-std/src/Vm.sol";
import "../src/AuctionNFT.sol";
import "../src/BlindAuction.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";

contract BlindAuctionTest is Test {
    // Counter public counter;
    BlindAuction public blindAuction;
    EthersFuture public ethersFuture;
    string NFTURI;

    function setUp() public {
        vm.startPrank(0xBB9F947cB5b21292DE59EFB0b1e158e90859dddb);
        blindAuction = new BlindAuction();
        ethersFuture = new EthersFuture("EthersFuture", "ETF");
        NFTURI = "QmWUshz9TpZEt69rZ48CsSE3kD3dRGYNDYcwvMXqHFcqRt";
        ethersFuture.safeMint(
            0xBB9F947cB5b21292DE59EFB0b1e158e90859dddb,
            NFTURI
        );
        vm.stopPrank();
    }

    function testCreateAuction() public {
        runAprove(4, 3, 3, 0);
    }

    function placeBid(address user, uint _value, uint id) internal {
        vm.prank(address(user));
        vm.deal(address(user), 50 ether);
        blindAuction.placeHiddenBid{value: _value}(id);
    }

    function revealBid(address _user, uint _voteId, uint _bidAmount) internal {
        vm.prank(address(_user));
        blindAuction.revealBid(_voteId, _bidAmount);
    }

    function withdraw(address _user, uint _voteId) internal {
        vm.prank(address(_user));
        blindAuction.withdraw(_voteId);
    }

    function runAprove(
        uint _voteId,
        uint _bidTime,
        uint _revealTime,
        uint nftId
    ) internal {
        vm.startPrank(0xBB9F947cB5b21292DE59EFB0b1e158e90859dddb);
        ethersFuture.approve(address(blindAuction), 0);
        blindAuction.createAuction(
            _voteId,
            _bidTime,
            _revealTime,
            address(ethersFuture),
            nftId,
            1
        );
        vm.stopPrank();

        placeBid(
            0x13B109506Ab1b120C82D0d342c5E64401a5B6381,
            (2 * 1e18),
            _voteId
        );
        placeBid(
            0xA771E1625DD4FAa2Ff0a41FA119Eb9644c9A46C8,
            (3 * 1e18),
            _voteId
        );
        placeBid(
            0xfd182E53C17BD167ABa87592C5ef6414D25bb9B4,
            (4 * 1e18),
            _voteId
        );
        vm.warp(block.timestamp + (_bidTime * 1.2 minutes));

        revealBid(
            0x13B109506Ab1b120C82D0d342c5E64401a5B6381,
            _voteId,
            (2 * 1e18)
        );
        revealBid(
            0xA771E1625DD4FAa2Ff0a41FA119Eb9644c9A46C8,
            _voteId,
            (3 * 1e18)
        );
        revealBid(
            0xfd182E53C17BD167ABa87592C5ef6414D25bb9B4,
            _voteId,
            (4 * 1e18)
        );
        vm.warp(block.timestamp + (_revealTime * 1 minutes));
        blindAuction.auctionEnd(_voteId);
        withdraw(0x13B109506Ab1b120C82D0d342c5E64401a5B6381, _voteId);
        withdraw(0xA771E1625DD4FAa2Ff0a41FA119Eb9644c9A46C8, _voteId);

        // withdraw(0xfd182E53C17BD167ABa87592C5ef6414D25bb9B4, _voteId);

        // Log addresses to check which of them won the auction
        displayBalance(0x13B109506Ab1b120C82D0d342c5E64401a5B6381);
        displayBalance(0xA771E1625DD4FAa2Ff0a41FA119Eb9644c9A46C8);
        displayBalance(0xfd182E53C17BD167ABa87592C5ef6414D25bb9B4);
        console.log(address(this).balance);
        displayBalance(0xBB9F947cB5b21292DE59EFB0b1e158e90859dddb);
    }

    function displayBalance(address _add) public view {
        console.log(_add.balance);
    }

    function testCreateAuctionAndBidSuccessfully() public view {}
}

// 4000000000000000000

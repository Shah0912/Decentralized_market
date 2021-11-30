// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./DeedRepository.sol";

contract AuctionRepository  {
    
    // Array with all auctions
    Auction[] public auctions;

    // Mapping from auction index to user bids
    mapping(uint256 => Bid[]) public auctionBids;

    // Mapping from owner to a list of owned auctions
    mapping(address => uint[]) public auctionOwner;

    // Bid struct to hold bidder and amount
    struct Bid {
        address payable from;
        uint256 amount;
    }

    // Auction struct which holds all the required info
    struct Auction {
        string name;
        uint256 startBlock;
        uint256 endBlock;
        uint256 startPrice;
        string metadata;
        uint256 deedId;
        address deedRepositoryAddress;
        address owner;
        bool active;
        bool finalized;
    }
    
    modifier isOwner(uint _auctionId) {
        require(auctions[_auctionId].owner == msg.sender);
        _;
    }
    
    modifier contractHasDeedApproval(address _deedRepositoryAddress, uint256 _deedId) {
        address deedApproval = DeedRepository(_deedRepositoryAddress).getApproved(_deedId);
        require(deedApproval == address(this));
        _;
    }

    modifier auctionIsActive(uint _auctionId) {
        require(auctions.length > _auctionId);
        require(auctions[_auctionId].active == true);
        require(auctions[_auctionId].finalized == false);
        uint current_block = getCurrentBlock();
        require(current_block >= auctions[_auctionId].startBlock);
        require(current_block < auctions[_auctionId].endBlock);
        _;
    }
    
    function createAuction(address _deedRepositoryAddress, uint256 _deedId, string memory _auctionTitle, string memory _metadata, uint256 _startPrice, uint256 _startBlock, uint256 _endBlock) public contractHasDeedApproval(_deedRepositoryAddress, _deedId) returns(bool) {
        uint auctionId = auctions.length;
        Auction memory newAuction;
        newAuction.name = _auctionTitle;
        newAuction.startBlock = _startBlock;
        newAuction.endBlock = _endBlock;
        // newAuction.startTime = block.timestamp;
        newAuction.startPrice = _startPrice;
        newAuction.metadata = _metadata;
        newAuction.deedId = _deedId;
        newAuction.deedRepositoryAddress = _deedRepositoryAddress;
        newAuction.owner = msg.sender;
        newAuction.active = true;
        newAuction.finalized = false;

        auctions.push(newAuction);        
        auctionOwner[msg.sender].push(auctionId);
        
        // emit AuctionCreated(msg.sender, auctionId);
        return true;
    }
    
    function getCurrentBlock() public view returns(uint256) {
        return block.number;
    }

    function bid(uint _auctionId) public payable auctionIsActive(_auctionId) {
        uint256 ethAmountSent = msg.value;

        Auction memory myAuction = auctions[_auctionId];
        require(msg.sender != auctions[_auctionId].owner);

        uint bidsLength = auctionBids[_auctionId].length;
        uint256 tempAmount = myAuction.startPrice;
        Bid memory lastBid;

        if(bidsLength > 0) {
            lastBid = auctionBids[_auctionId][bidsLength - 1];
            tempAmount = lastBid.amount;
        }
        
        if(ethAmountSent <= tempAmount)  revert();

        if(bidsLength > 0) {
            if(!payable(lastBid.from).send(lastBid.amount)) revert();
        }

        Bid memory newBid;
        newBid.from = payable(msg.sender);
        newBid.amount = ethAmountSent;
        auctionBids[_auctionId].push(newBid);

    }

    function cancelAuction(uint _auctionId) public isOwner(_auctionId) {
        uint bidsLength = auctionBids[_auctionId].length;

        // if there are bids refund the last bid
        if( bidsLength > 0 ) {
            Bid memory lastBid = auctionBids[_auctionId][bidsLength - 1];
            if(!payable(lastBid.from).send(lastBid.amount)) revert();
        }
        auctions[_auctionId].active = false;

        // approve and transfer from this contract to auction owner
        // if(approveAndTransfer(address(this), myAuction.owner, myAuction.deedRepositoryAddress, myAuction.deedId)){
        //     auctions[_auctionId].active = false;
        //     emit AuctionCanceled(msg.sender, _auctionId);
        // }
    }
    function finaliseAuction(uint _auctionId) public isOwner(_auctionId) {
            Auction memory myAuction = auctions[_auctionId];
            uint bidsLength = auctionBids[_auctionId].length;
            Bid memory lastBid;
            address winner;
            if(bidsLength > 0) {
                 lastBid = auctionBids[_auctionId][bidsLength - 1];
                 winner = lastBid.from;
             }
            address owner=myAuction.owner;
            uint tokenId=myAuction.deedId;
            DeedRepository(myAuction.deedRepositoryAddress).safeTransferFrom(owner,winner,tokenId);
            auctions[_auctionId].finalized = true;
            auctions[_auctionId].active = false;

    }
}

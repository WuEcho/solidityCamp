// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

import "./echoNFT.sol";
import "./IERC721Receiver.sol";
contract NFTMarket is IERC721Receiver {
    constructor() {}

    function onERC721Received(
        address operator,
        address from,
        uint tokenId,
        bytes calldata data
    ) external override pure returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    receive() external payable {}
    fallback() external payable {}

    struct Order {
        address owner;
        uint256 price;
    }

    mapping(address=>mapping(uint256=>Order)) public nftList;

    event List(address indexed sender,address indexed ntfaddress,uint256 indexed tokenId,uint256 price);
    event Revoke(address indexed sender,address indexed ntfAddrss,uint256 tokenId);
    event Update(address indexed sender,address indexed ntfAddrss,uint256 tokenId,uint256 price);
    event Buy(address indexed buyer,address indexed ntfAddrss,uint256 tokenId);

    function list(address nftAddress,uint256 tokenId,uint256 price) public {
      require(nftAddress != address(0),"nft address must be available address");
      require(price > 0, "price should be Legal");
      EchoNft token = EchoNft(nftAddress);
      require(token.getApproved(tokenId) == address(this),"not approved");
      Order storage order = nftList[nftAddress][tokenId];
      order.owner = msg.sender;
      order.price = price;
      token.safeTransferFrom(msg.sender, address(this), tokenId);
      emit List(msg.sender,nftAddress,tokenId,price);
    }


    function revoke(address nftAddress,uint256 tokenId) public {
      require(nftAddress != address(0),"nft address must be available address");
      Order storage order = nftList[nftAddress][tokenId];
      require(order.owner == msg.sender);
      EchoNft token = EchoNft(nftAddress);
      require(token.ownerOf(tokenId) == address(this),"tokenId not in this market");
      token.safeTransferFrom(address(this), msg.sender,tokenId);
      delete nftList[nftAddress][tokenId];
      emit Revoke(msg.sender,nftAddress,tokenId);
    }

    function update(address nftAddress,uint256 tokenId,uint256 price) public {
      require(nftAddress != address(0),"nft address must be available address");
      require(price > 0, "price should be Legal");
      Order storage order = nftList[nftAddress][tokenId];
      require(order.owner == msg.sender);
      EchoNft token = EchoNft(nftAddress);
      require(token.ownerOf(tokenId) == address(this),"tokenId not in this market");
      order.price = price;
      emit Update(msg.sender, nftAddress, tokenId, price);
    }

    function pay(address nftAddress,uint256 tokenId) external payable  {
      require(nftAddress != address(0),"nft address must be available address");
      Order storage order = nftList[nftAddress][tokenId];
      require(msg.value >= order.price);
      EchoNft token = EchoNft(nftAddress);
      uint256 left = msg.value - order.price;
      token.safeTransferFrom(address(this), msg.sender, tokenId);
      delete nftList[nftAddress][tokenId];
      payable(order.owner).transfer(order.price);
      payable(msg.sender).transfer(left);
      emit Buy(msg.sender,nftAddress,tokenId);
    }

}
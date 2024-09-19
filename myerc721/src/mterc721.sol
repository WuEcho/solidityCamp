// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyERC721  is ERC721, Ownable {
   uint256 private _tokenId;
   string private _baseTokenURI;
   constructor(string memory name,string memory symbol,string memory baseTokenUri) ERC721(name,symbol) Ownable(msg.sender){
      _baseTokenURI = baseTokenUri;
      _tokenId = 1;
   }
   
   function mintToken(address to) public onlyOwner {
      uint256 tokenId = _tokenId;
      _safeMint(to, tokenId);
      _tokenId += 1;
   }

   function setBasicUrl(string memory basicURL) public onlyOwner{
      _baseTokenURI = basicURL;
   }

   function _baseURI() internal view override returns(string memory) {
      return _baseTokenURI;
   }

}
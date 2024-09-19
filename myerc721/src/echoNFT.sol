// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

import "./MyERC721.sol";

contract EchoNft is ERC721 {
   uint256 private totalSupply;
   constructor(string memory name,string memory symbol,uint256 _totalsupply) ERC721(name,symbol) {
      totalSupply = _totalsupply;
   }

  function setBasicRootURI() internal {
    setBaseURI("https://ipfs.io/ipfs/QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/");
  }

   function mintToken(address _owner,uint256 tokenid) external {
      require(tokenid >=0 && tokenid <= totalSupply,"tokenId out of range");
      _mint(_owner, tokenid);  
      emit Transfer(address(0), _owner, tokenid);
   }
}
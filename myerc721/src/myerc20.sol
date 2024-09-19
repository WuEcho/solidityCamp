// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyERC201 is ERC20 {
  constructor(uint256 _initalSuppory) ERC20("myToken","mt"){
    _mint(msg.sender,_initalSuppory);
  }

  
}
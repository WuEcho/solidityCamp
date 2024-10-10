// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {ERC20,IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract amm is ERC20 {
    IERC20 public weth;
    IERC20 public token;

    uint256 reserveWeth;
    uint256 reserveToken;

    constructor(
      address wethaddress,
      address tokenAddress
    ) ERC20("",""){

    }

}
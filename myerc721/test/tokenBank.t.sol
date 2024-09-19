// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import {Test, console} from "forge-std/Test.sol";
import {TokenBank} from "../src/tokenBank.sol";
import {MyERC20Token} from "../src/MyERC201.sol";
contract TokenBankTest is Test{
  address caller = makeAddr("caller");  
 
  function test_mint() public {
    vm.startPrank(caller);
    MyERC20Token token = new MyERC20Token("MyToken","mt");
    token.mint(100000);
    assertEq(token.balanceOf(caller), 100000);
    vm.stopPrank();
  }
 
  address _spender = makeAddr("spender");
  function test_approval() public {
     vm.startPrank(caller);
     MyERC20Token token = new MyERC20Token("MyToken","mt");
     token.mint(1000);
     token.approve(_spender, 100);
     assertEq(token.allowance(caller,_spender),100);
     vm.stopPrank();
  }

  function test_transfer(uint256 value) public {
    vm.startPrank(caller);
    MyERC20Token token = new MyERC20Token("MyToken","mt");
    token.mint(value);
    token.transfer(_spender, value);
    assertEq(token.balanceOf(_spender), value);
    vm.stopPrank();
  }

  function test_deposit() public {
    vm.startPrank(caller);
    MyERC20Token token = new MyERC20Token("MyToken","mt");
    token.mint(1000);
    TokenBank bank = new TokenBank(address(token));
    token.approve(address(bank), 100);
    bank.deposit(100);
    assertEq(bank.checkBalance(caller), 100);
    vm.stopPrank();
  }

}
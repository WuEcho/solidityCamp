//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;
import "./MyERC201.sol";

contract TokenBank {
      address private owner;
      address tokenAddress;
      mapping(address => uint256) balances;

      event Deposit(address indexed _sender,uint256 value);
      event WithDraw(address indexed _sender,uint256 value);

      bool public flag;
      constructor(address _tokenAddress){
          tokenAddress = _tokenAddress;
          owner = msg.sender;
      }

      modifier relayLock() {
        require(flag == false,"relay");
        flag = true;
        _;
      }

      receive() external payable {}

      function deposit(uint256 amount) public returns(bool){
        MyERC20Token token = MyERC20Token(tokenAddress);
        require(token.balanceOf(msg.sender) >= amount,"Insufficient token balance");
        require(token.transferFrom(msg.sender,address(this),amount),"token trans failed");
        balances[msg.sender] += amount;
        emit Deposit(msg.sender,amount);
        return true;
      }

      function checkBalance(address _owner) public view returns(uint256) {
        return balances[_owner];
      }

      function withdraw() public relayLock returns(bool) {
        require(balances[msg.sender] >= 0,"you dont have balance");
        uint256 value = balances[msg.sender];
        balances[msg.sender] = 0;
        MyERC20Token token = MyERC20Token(tokenAddress);
        require(token.transfer(msg.sender, value));
        flag = false;
        return true;
      }

}

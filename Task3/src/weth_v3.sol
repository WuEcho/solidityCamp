// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract WETHToken is ERC20,Ownable  {

    constructor() ERC20("WETH","WETH") Ownable(_msgSender()) {}

    event Deposit(address indexed sender,uint256 amount);
    event WithDraw(address indexed sender,uint256 amount);

    error AmountMustBeGenerateThanZero();
    error InsufficientBalance(uint256 amount);
    error TransferFailed();
    receive() external payable{
      deposit();
    }

    fallback() external payable{
      deposit();
    }


    function deposit() payable public returns(bool) {
        if(msg.value <= 0) {
            revert AmountMustBeGenerateThanZero();
        }
        _mint(_msgSender(), msg.value);
        emit Deposit(msg.sender,msg.value);
        return true;
    }


    function withDraw(uint256 amount) public returns(bool) {
        uint256 balance = balanceOf(msg.sender);
        if(amount <= 0){
            revert AmountMustBeGenerateThanZero();
        }

        if(balance < amount){
          revert InsufficientBalance(amount);
        }
        _burn(_msgSender(),amount);
        (bool sucess,) = msg.sender.call{value:amount}("");
        require(sucess,"with draw failed");
        if(!sucess){
          revert TransferFailed();
        }
        emit WithDraw(msg.sender,amount);
        return true;
    }

    function transfer(address to,uint256 amount) public override returns(bool) {
        if(amount >= balanceOf(_msgSender())) {
            revert InsufficientBalance(amount);
        }
        return super.transfer(to,amount);
    }

    function transferFrom(address from,address to,uint256 amount) public override returns(bool) {
      if(amount >= balanceOf(from)) {
            revert InsufficientBalance(amount);
      }
      return super.transferFrom(from,to,amount);
    }
}
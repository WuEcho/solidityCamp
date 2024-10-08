// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract WETHToken is ERC20,Ownable  {

    constructor() ERC20("WETH","WETH") Ownable(_msgSender()) {}

    event Deposit(address indexed sender,uint256 amount);
    event WithDraw(address indexed sender,uint256 amount);

    receive() external payable{
      deposit();
    }

    fallback() external payable{
      deposit();
    }


    function deposit() payable public returns(bool) {
        require(msg.value > 0, "value is availabel");
        _mint(_msgSender(), msg.value);
        emit Deposit(msg.sender,msg.value);
        return true;
    }


    function withDraw() public returns(bool) {
        uint256 amount = balanceOf(msg.sender);
        require(amount >=0,"you cantnot withdraw");
        _burn(_msgSender(),amount);
        (bool sucess,) = msg.sender.call{value:amount}("");
        require(sucess,"with draw failed");
        emit WithDraw(msg.sender,amount);
        return true;
    }

    function transfer(address to,uint256 amount) public override returns(bool) {
        require(amount >= balanceOf(_msgSender()),"balance not enough");
        return super.transfer(to,amount);
    }

    function transferFrom(address from,address to,uint256 amount) public override returns(bool) {
      require(amount >= balanceOf(from),"balance of from is not enough");
      return super.transferFrom(from,to,amount);
    }
}
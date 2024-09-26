// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WETHToken is ERC20  {

    constructor() ERC20("WETH","WETH"){}

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
        _mint(msg.sender, msg.value);
        emit Deposit(msg.sender,msg.value);
        return true;
    }


    function withDraw() public returns(bool) {
        uint256 amount = balanceOf(msg.sender);
        require(amount >=0,"you cantnot withdraw");
        _burn(msg.sender,amount);
        (bool sucess,) = msg.sender.call{value:amount}("");
        require(sucess,"with draw failed");
        emit WithDraw(msg.sender,amount);
        return true;
    }

}
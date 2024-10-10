// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
contract WETHAAMPool {
    IERC20 public WETH;    
    IERC20 public Token;
    uint256 public totalLiquidity;
    mapping(address => uint256) public liquidity;

    constructor(address _wthAddress,address _tokenAddress) {
        WETH = IERC20(_wthAddress);
        Token = IERC20(_tokenAddress);
    }

    function addLiquendy(uint256 _wethAmount,uint256 _tokenAmount) external returns(uint256)  {
        require(_wethAmount >0 && _tokenAmount > 0, "amount should be liegal");
        uint256 liquidityAdd;
        if (totalLiquidity == 0) {
            liquidityAdd = _wethAmount * _tokenAmount;
        }else{
            liquidityAdd = totalLiquidity * _wethAmount /  WETH.balanceOf(address(this));
        }


        liquidity[msg.sender] += liquidityAdd;
        totalLiquidity += liquidityAdd;

        Token.transferFrom(msg.sender, address(this), _tokenAmount);
        WETH.transferFrom(msg.sender, address(this), _wethAmount);
        return liquidityAdd;
    }

    function removeLiquendy(uint256 amount) external {
        require(amount > 0 && liquidity[msg.sender] >= amount,"amount should be liegal");
      
        uint256 tokenReserve = Token.balanceOf(address(this));
        uint256 wethReserve = WETH.balanceOf(address(this));

        uint256 tokenAmount = tokenReserve * amount / totalLiquidity;
        uint256 wethAmount = wethReserve * amount / totalLiquidity;

        liquidity[msg.sender] -= amount;
        totalLiquidity -= amount;
        WETH.transfer(msg.sender, tokenAmount);
        Token.transfer(msg.sender, wethAmount);
    }

    function swapWETHForToken(uint256 _wethAmount) external returns(uint256){
        require(_wethAmount > 0 ,"_wethAmount should be Available");
        uint256 tokenReserve = Token.balanceOf(address(this));
        uint256 wethReserve = WETH.balanceOf(address(this));
        //x * y = k
        //(x + ^x) * (y - ^y) = k
        //^y =  y - k/(x + ^x) 
        uint256 wethAfter = wethReserve + _wethAmount;
        uint256 k = tokenReserve * wethReserve;
        uint256 tokenAmount = tokenReserve - (k/wethAfter);

        WETH.transferFrom(msg.sender, address(this), _wethAmount);
        Token.transfer(msg.sender, tokenAmount);
        return tokenAmount;
    }

    //(x - ^x) * (y + ^ y) = k
    function swapTokenForWeth(uint256 _tokenAmount) external returns(uint256){
        require(_tokenAmount > 0, "_tokenAmount should be Available");
        uint256 tokenReserve = Token.balanceOf(address(this));
        uint256 wethReserve = WETH.balanceOf(address(this));
        uint256 _tokenAfter = tokenReserve + _tokenAmount;
        uint256 k = tokenReserve * wethReserve;
        uint256 liq = wethReserve - (k / _tokenAfter);
        Token.transferFrom(msg.sender, address(this), _tokenAmount);
        WETH.transfer(msg.sender, liq);
        return liq;
    }

   function getReserves() external view returns(uint256,uint256) {
        uint256 tokenReserve = Token.balanceOf(address(this));
        uint256 wethReserve = WETH.balanceOf(address(this));
        return (tokenReserve,wethReserve);
   }


}  
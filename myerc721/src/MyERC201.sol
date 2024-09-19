//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;
contract MyERC20Token {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    address private owner;

    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowances;

    event Transfer(address indexed _spoder, address indexed _to, uint256 value);
    event Approved(address indexed _spoder, address indexed _to, uint256 value);

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        owner = msg.sender;
        decimals = 18;
    }

    modifier onlyOWner() {
        require(msg.sender == owner, "must be owner");
        _;
    }

    function balanceOf(address _spender) public view returns (uint256) {
        return balances[_spender];
    }

    function allowance(
        address _owner,
        address _spender
    ) public view returns (uint256) {
        return allowances[_owner][_spender];
    }

    function approve(address _spender, uint256 value) public returns (bool) {
        allowances[msg.sender][_spender] = value;
        emit Approved(msg.sender, _spender, value);
        return true;
    }

    function TotalSupply() public view returns (uint256) {
        return totalSupply;
    }

    function transfer(address _to, uint256 value) public returns (bool) {
        require(balances[msg.sender] >= value, "balance not enough");
        balances[msg.sender] -= value;
        balances[_to] += value;
        emit Transfer(msg.sender, _to, value);
        return true;
    }

    function transferFrom(
        address _spode,
        address _to,
        uint256 value
    ) public returns (bool) {
        require(balances[_spode] >= value, "balance no enough");
        require(allowances[_spode][msg.sender] >= value, "balance not enough");
        balances[_spode] -= value;
        allowances[_spode][msg.sender] -= value;
        balances[_to] += value;
        emit Transfer(_spode, _to, value);
        return true;
    }

    function mint(uint256 value) public onlyOWner {
        balances[msg.sender] += value;
        totalSupply += value;
        emit Transfer(address(0), msg.sender, value);
    }

    function burn(uint256 value) public onlyOWner {
        balances[msg.sender] -= value;
        totalSupply -= value;
        emit Transfer(msg.sender, address(0), value);
    }
}

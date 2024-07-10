pragma solidity ^0.8.0;

contract VulnerableTokenFix {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public lockTime;

    constructor() {
        balances[msg.sender] = 1000; // Initial supply
    }

    function lockToken(uint256 _time) public {
        require(balances[msg.sender] > 0, 'No tokens to lock');
        lockTime[msg.sender] = block.timestamp + _time;
    }

    function unlockToken() public {
        require(block.timestamp >= lockTime[msg.sender], 'Lock time not yet expired');
        lockTime[msg.sender] = 0;
    }

    function transfer(address _to, uint256 _amount) public {
        require(balances[msg.sender] >= _amount, 'Insufficient balance');
        require(block.timestamp >= lockTime[msg.sender], 'Tokens are locked');

        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }
}

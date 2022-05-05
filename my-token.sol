pragma solidity ^0.8.2;

// The Methods are not chosen at random but are part of the BEP2 / BEP20 standard added the BEP20 openzeppelin contract as a reference.
// This MVP functionality for a token misses some practical func compared to that a BEP20 openzeppelin func.
// Authorization functionality.
// Transference of ownership
// Minting of tokens
// Etc.

contract MyToken {
    // Map that holds all the addresses vs number of tokens
    mapping(address => uint) public balances;
    // Map holding a map with address as key..
    mapping(address => mapping(address => uint)) public allowance; // address (owner of token) => address (spender)  => uint how much owner can spend.
    // Number of tokens to create at the beginning.
    uint public totalSupply = 10000000000 * 10 ** 18; // 10 billion tokens, with 18 decimals.
    string public name = "Something Token";
    string public symbol = "SOME";
    uint public decimals = 18;

    // Create some events to give transparency about event status in the contract.
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);

    constructor() {
        // Set the initial balance of the creator to the total supply.
        balances[msg.sender] = totalSupply;
    }

    // Balances of every known owner
    function balanceOf(address owner) public returns(uint) { // Video had view modifier here.
        return balances[owner];
    }

    // Used to transfer tokens by anyone owning these tokens to a recipient.
    function transfer(address to, uint value) public returns(bool) {
        require(balanceOf(msg.sender) >= value, 'balance too low'); // blance of sender account is to lower then value to transfer to the receiver.
        balances[to] += value;  // increase the balance of the receiver.
        balances[msg.sender] -= value; // decrease the balance balanceOf
        emit Transfer(msg.sender, to, value);
        return true;
    }

    // Use to transfer token
    function transferFrom(address from, address to, uint value) public returns(bool) {
        require(balanceOf(from) >= value, 'balance too low'); // balance of the owner should be higher then the number of tokens to transfer.
        require(allowance[from][msg.sender] >= value, 'allowance too low'); // check if the allowance is enough to transfer the value.
        balances[to] += value; // increase the balance of the receiver.
        balances[from] -= value; // decrease the balance of the sender.
        emit Transfer(from, to, value); // emit the transfer event.
        return true;
    }

    // The owner can allow dexes to spend x tokens each time... when someone want to buy them.. With a set uppper limit.
    function approve(address spender, uint value) public returns (bool) {
        allowance[msg.sender][spender] = value; // the spender a dex can spend a max of X belonging to owner.
        emit Approval(msg.sender, spender, value); // emit owner approves a certain spender to max spend x each time.
        return true;
    }
}

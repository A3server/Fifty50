pragma solidity ^0.8.2;

contract myToken {
    address public minter; //a pessoa que criou o contrato
    mapping(address => uint256) public balances; //mapping em que um endereço corresponde a uma uint (balance)

    event Sent(address from, address to, uint256 amount);

    constructor() {
        minter = msg.sender;
    }

    function mint(address receiver, uint256 amount) public {
        require(msg.sender == minter); //ver se o addrs é o que dá mint
        balances[receiver] += amount; //se sim adiciona a esse address
    }

    function send(address receiver, uint256 amount) public {
        require(amount <= balances[msg.sender], "Insufficient Balance"); //check sufecient balance in that address
        balances[msg.sender] -= amount; //tiro de quem mandou
        balances[receiver] += amount; //meto de quem recebe
        emit Sent(msg.sender, receiver, amount);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";
import "@nomiclabs/buidler/console.sol";

contract myToken is VRFConsumerBase {
    bytes32 internal keyHash;
    uint256 internal fee;

    uint256 public randomResult;

    uint256 public initialSupply = 100 * 10**18;

    address public minter; //a pessoa que criou o contrato
    mapping(address => uint256) public balances; //mapping em que um endereço corresponde a uma uint (balance)

    event Sent(address from, address to, uint256 amount);
    event Minted(address receiver, uint256 _value, uint256 newammount);

    constructor()
        public
        VRFConsumerBase(
            0xa555fC018435bef5A13C6c6870a9d4C11DEC329C, // VRF Coordinator
            0x84b9B910527Ad5C03A9Ca831909E21e236EA7b06 // LINK Token
        )
    {
        minter = msg.sender;
        keyHash = 0xcaf3c3727e033261d383b315559476f48034c13b18f8cafed4d871abe5049186;
        fee = 0.1 * 10**18; // 0.1 link
    }

    function mint(address receiver, uint256 amount) public {
        require(msg.sender == minter); //ver se o addrs é o que dá mint
        balances[receiver] += amount; //se sim adiciona a esse address
        emit Minted(msg.sender, amount, balances[receiver]);
    }

    function send(address receiver, uint256 amount) public {
        require(amount <= balances[msg.sender], "Insufficient Balance"); //check sufecient balance in that address
        balances[msg.sender] -= amount; //tiro de quem mandou
        balances[receiver] += amount; //meto de quem recebe
        emit Sent(msg.sender, receiver, amount);
    }

    function getRandomNumber() public returns (bytes32 requestId) {
        console.log(fee);
        require(
            balances[address(this)] >= fee,
            "Not enough TKN - fill contract with faucet"
        );

        return requestRandomness(keyHash, fee);
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness)
        internal
        override
    {
        randomResult = randomness;
    }
}

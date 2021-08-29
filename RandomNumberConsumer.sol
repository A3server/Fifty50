// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";
import "./MyContract.sol";

contract RandomNumberConsumer is VRFConsumerBase {
    bytes32 internal keyHash;
    uint256 internal fee;

    uint256 public randomResult;

    /*
    
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
    PARA PRODUCTION USAR ESTE:
        http://prntscr.com/1qqirtz from https://docs.chain.link/docs/vrf-contracts/
        
        
        Replace:
        
        constructor() 
        VRFConsumerBase(
            0x747973a5A2a4Ae1D3a8fDF5479f1514F65Db9C31, // VRF Coordinator
            0x404460C6A5EdE2D891e8297795264fDe62ADBB75  // LINK Token
        ) public
        {
            keyHash = 0xc251acd21ec4fb7f31bb8868288bfdbaeb4fbfec2df3735ddbd4f7dc8d60103c;
            fee = 0.2 * 10 ** 18; // 0.2 LINK
        }
    
    */

    //calling myToken
    myToken tok;

    //constructor da main NET da Binance Smart Chain.
    constructor()
        public
        VRFConsumerBase(
            0xa555fC018435bef5A13C6c6870a9d4C11DEC329C, // VRF Coordinator
            0x84b9B910527Ad5C03A9Ca831909E21e236EA7b06 // LINK Token
        )
    {
        keyHash = 0xcaf3c3727e033261d383b315559476f48034c13b18f8cafed4d871abe5049186;
        fee = 0.1 * 10**18; // 0.1 link de fee
    }

    function getRandomNumber() public returns (bytes32 requestId) {
        require(
            tok.balanceOf(address(this)) > fee,
            "Not enough Tokens - fill contract with faucet"
        );
        return requestRandomness(keyHash, fee); //no need to pass userProvidedSeed, eles já fazem a sua seed por si
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness)
        internal
        override
    {
        require(tok.totalSupply() > 0, "Not enough players");
        randomResult = randomness;
    }

    // function withdrawLink() external {} - Implement a withdraw function to avoid locking your LINK in the contract
}

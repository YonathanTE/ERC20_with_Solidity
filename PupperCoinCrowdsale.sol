pragma solidity ^0.5.0; 

/* Crowdsale contract is supposed to mint, so that component of the contract(s) from our 
class examples will be brought here.
*/

// http://remix.ethereum.org/#optimize=false&runs=200&evmVersion=null&version=soljson-v0.5.17+commit.d19bba13.js

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// Order of inherit: From left to right, go off of base types.
// Upon my restart, test the imports ONE BY ONE.
contract PupperCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale { // Order matters with these parent contracts
    
    // IMPORTANT NOTE: constructor can only be deployed/executed ONCE per contract 
    constructor(uint rate, address payable wallet, PupperCoin token, uint goal, uint256 openingTime, uint256 closingTime)  //abstract method(s) from any of the imported contracts might be causing the error(s)
    // constructor gets two visibility keywords: public or internal
    // inherited contracts are read from right to left *
    Crowdsale(rate, wallet, token) 
    CappedCrowdsale(goal) 
    // MintedCrowdsale() (Isn't needed, will automatically be called)
    TimedCrowdsale(openingTime, closingTime) 
    RefundableCrowdsale(goal)
    public
    { 
    }
}

contract PupperCoinSaleDeployer { 
    
    // These state variables are needed or else the contract won't display these once deployed.
    address public token_sale_address; // Doesn't work and I'm not sure why... (Logic?)
    address public token_address;
    
    // Make state variables within the constructor and no _ for variables.
    constructor(string memory name, string memory symbol, address payable wallet, uint256 goal) 
    public {
        
    PupperCoin token = new PupperCoin(name, symbol, 0);
    // Don't add address before the variable or else the contract won't give an address after being deployed.
    token_address = address(token);

    PupperCoinSale token_sale = new PupperCoinSale(1, wallet, token, goal, now, now + 24 weeks); 
    // Don't add address before the variable or else the contract won't give an address after being deployed.
    token_sale_address = address(token_sale); 
    
    // Make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
    token.addMinter(token_sale_address); 
    token.renounceMinter();
    }
   
}
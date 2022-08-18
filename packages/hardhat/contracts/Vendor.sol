// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

///@notice Ownable contract imported from Openzeppelin, sets the deployer as the owner of the contract
import "@openzeppelin/contracts/access/Ownable.sol";

///@notice Token contract
///@dev Token contract is located in the same directory as the Vendor contract
import "./YourToken.sol";

///@title Token Vendor
///@notice Lets the user buy, sell tokens with ETH
///@custom:developer jooohn.eth 
contract Vendor is Ownable {

  ///@notice An event that is emitted after a user buys a token
  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

  ///@notice An event that is emitted after a user sells a token
  event SellTokens(address seller, uint256 amountOfETH, uint256 amountOfTokens);

  ///@notice Amount of tokens per 1 ETH
  uint public constant tokensPerEth = 100;

  ///@notice Token contract
  YourToken public yourToken;

  ///@notice Initializes the token with token address
  ///@param tokenAddress Address of a deployed token
  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  ///@notice Lets the user buy a token
  function buyTokens() external payable {

    uint amountOfTokens = tokensPerEth * msg.value;

    yourToken.transfer(msg.sender, amountOfTokens);

    emit BuyTokens(msg.sender, msg.value, amountOfTokens);
  }

  ///@notice Lets the owner/deployer of the contract to withdraw funds to his wallet
  function withdraw() external onlyOwner{
    
    payable(msg.sender).transfer(address(this).balance);

  }


  ///@notice Lets the user sell back the Tokens for ETH
  ///@param _amount Amount of tokens the user wants to sell
  ///@dev Notice the uint() a wrapped around _amount and tokensPerEth in the division, its to avoid having floats that may cause bugs
  function sellTokens(uint256 _amount) external {

    yourToken.transferFrom(msg.sender, address(this), _amount);

    (bool success, ) = msg.sender.call{value: uint(_amount) / uint(tokensPerEth)}("");
    require(success, "Transaction failed!");

    emit SellTokens(msg.sender, uint(_amount) / uint(tokensPerEth), _amount);

  }

}

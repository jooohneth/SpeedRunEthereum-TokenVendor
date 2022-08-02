pragma solidity 0.8.15;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

  uint public constant tokensPerEth = 100;

  YourToken public yourToken;

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:
  
  function buyTokens() external payable {

    uint amountOfTokens = tokensPerEth * msg.value;

    yourToken.transfer(msg.sender, amountOfTokens);

    emit BuyTokens(msg.sender, msg.value, amountOfTokens);
  }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH

  function withdraw() external onlyOwner{
    
    payable(msg.sender).transfer(address(this).balance);

  }


  // ToDo: create a sellTokens(uint256 _amount) function:

  function sellTokens(uint256 _amount) external {

    yourToken.transferFrom(msg.sender, address(this), _amount);

    //added uint specification for each element in the division to avoid having weird floats, not sure what the problem is(found solution on stackoverflow)"
    payable(msg.sender).transfer(uint(_amount) / uint(tokensPerEth));

  }

}

// SPDX-License-Identifier: MIT
// FREE CAMP CODE COURSE

pragma solidity >=0.6.6 <0.9.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {

    mapping(address => uint256) public addressToAmountFunded;
    address public  owner;
   constructor() public {

       owner = msg.sender;

   }
// payable function
    function fund() public payable {

        // minimium value to pay USD 50
        uint256 minimumUSD = 50 * 10 ** 18;
        require(getConversionRate(msg.value) >= minimumUSD, "You need to spend more ETH!");
        addressToAmountFunded[msg.sender] += msg.value ;       
        
   } 

// get the Version 
   function getVersion() public view returns(uint256){
       AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
       return priceFeed.version();  
   }

// get the Price
   function getPrice() public view returns(uint256){
        AggregatorV3Interface priceFeed =  AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        (,int256 answer,,,) = priceFeed.latestRoundData();    

        return uint256(answer);
        //  1,588.42000000
   }

// Convert USD to Eth
   function getConversionRate(uint256 ethAmount) public view returns (uint256){
       uint256 ethPrice = getPrice();
       uint256 ethAmountinUsd = (ethPrice * ethAmount / 1000000000000000000);
       return ethAmountinUsd;
   }

    function withdraw() public payable  {
     address payable to = payable(msg.sender);
      to.transfer(address(this).balance);
}
}
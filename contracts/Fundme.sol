// SPDX-License-Identifier: MIT
// FREE CAMP CODE COURSE

pragma solidity >=0.6.6 <0.9.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner;

    // the first person to deploy the contract is the owner
    constructor() public {
        owner = msg.sender;
    }

    // payable function
    function fund() public payable {
        // minimium value to pay USD 50 / the 18 digit number to be compared with donated amount
        uint256 minimumUSD = 50 * 10**18;
        require(
            getConversionRate(msg.value) >= minimumUSD,
            "You need to spend more ETH!"
        );

        // if is 50 or more, add to mapping
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    // get the Version
    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        );
        return priceFeed.version();
    }

    // get the Price
    function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        );
        (, int256 answer, , , ) = priceFeed.latestRoundData();

        // ETH/USD rate in 18 digit
        return uint256(answer * 10000000000);
        //  1,588.42000000
    }

    // Convert USD to Eth
    function getConversionRate(uint256 ethAmount)
        public
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice();
        uint256 ethAmountinUsd = ((ethPrice * ethAmount) / 1000000000000000000);
        return ethAmountinUsd;
    }

    //modifier: https://medium.com/coinmonks/solidity-tutorial-all-about-modifiers-a86cf81c14cb
    modifier onlyOwner() {
        // only the contract owner/admin can withdraw
        require(msg.sender == owner);
        _;
    }

    // onlyOwner modifier will first check the condition inside it and if its true, withdraw function will executed
    function withdraw() public payable onlyOwner {
        address payable to = payable(msg.sender);
        to.transfer(address(this).balance);
        // runs through all the mapping and make them o since all the deposited amount has been withdrawn
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        // funders array will be initialized to 0

        funders = new address[](0);
    }
}

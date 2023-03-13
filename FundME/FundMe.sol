// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;
import "./PriceConverter.sol";
error Unauthorized();

/**
 * @title this title should before contract
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract FundMe {
    using PriceConverter for uint256;
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;
    // constant keywords will save your gas
    uint256 public constant minimumUsd = 1 * 1e18;
    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        // msg.value 是有18位小数的1eth=100000000000000000wei
        require(
            msg.value.getConversionRate() >= minimumUsd,
            "didn't send enough"
        );
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

    function withdraw() public payable onlyOwner {
        // require(msg.sender == i_owner, "only i_owner can withdraw");
        for (uint256 i = 0; i < funders.length; i++) {
            address funder = funders[i];
            addressToAmountFunded[funder] = 0;
        }
        // reset funders array
        funders = new address[](0);
        // transfer if fail will throw error and revert
        // payable(msg.sender).transfer(address(this).balance);
        // // it will return a bool value,you can revert the fail transation through require
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // // this will revert the transation
        // require(sendSuccess, "send fail");
        // call
        (
            bool callSuccess, /*bytes memory dataReturned*/

        ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "call fail");
    }

    // modifier can do some guard
    modifier onlyOwner() {
        // require(msg.sender == i_owner, "only i_owner can withdraw");
        if (msg.sender != i_owner) {
            revert Unauthorized();
        }
        _;
    }

    // what happends if someone sends this contraacts ETH without calling the fund function
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}

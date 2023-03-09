//  SPDX-License-Identifier:MIT
pragma solidity ^0.8.7;

import "./SimpleStorage.sol";

// 如果要重载父合约的方法，需要将父合约的方法标记为 virtual
// 并将重载方法标记为override
contract ExtraStorage is SimpleStorage {
    function store(uint256 _favoriteNumber) public override {
        favoriteNumber = _favoriteNumber + 5;
    }
}

//  SPDX-License-Identifier:MIT
pragma solidity ^0.8.7;
import "./SimpleStorage.sol";

contract StorageFactory {
    SimpleStorage[] public simpleStorageArray;

    function createSimpleStorageContract() public {
        simpleStorageArray.push(new SimpleStorage());
    }

    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorafeNumber)
        public
    {
        // 这里可以通过simpleStorage数组获取到simpleStorage实例
        // 也可以通过address转化 SimpleStorage simpleStorage=SimpleStorage(simpleStorageArray[_simpleStorageIndex]);
        simpleStorageArray[_simpleStorageIndex].store(_simpleStorafeNumber);
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        return simpleStorageArray[_simpleStorageIndex].retrieve();
    }
}
//    在合约中创建合约的过程相当于部署一个新合约

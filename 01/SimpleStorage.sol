//  SPDX-License-Identifier:MIT
pragma solidity ^0.8.7;

struct People {
    //  可以根据属性的顺序初始化结构体
    uint256 favoriteNumber;
    string name;
}

contract SimpleStorage {
    uint256 favoriteNumber;
    People[] public people;
    mapping(string => uint) public nameToFavoriteNmber;

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }

    function retrieve() public view returns (uint256) {
        return favoriteNumber;
    }

    // pure 不能读取合约数据 纯函数
    // view 能读数据但是不能写数据
    // 只有改数据才消耗gas
    // 如果不是view或者pure函数调用了view或者pure函数则需要支付gas

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        // calldata memory意味着变量只是暂时存在，calldata不能被修改，memory可以被修改
        // calldata与memory只能用于Array struct mapping，String是特殊的array
        // storage可以存在方法外 favortiteNumber默认就是，是属于可以被修改的永久变量
        //
        people.push(People({name: _name, favoriteNumber: _favoriteNumber}));
        nameToFavoriteNmber[_name] = _favoriteNumber;
    }
}
// 部署到测试网络时候只需要将环境切换到injectd Provider上面，连接到metamask
// https://ethereum.stackexchange.com/questions/13625/injected-web3-is-not-working-in-browser-solidity

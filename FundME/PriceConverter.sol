// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice() internal view returns (uint256) {
        // 根据库的不同，小数运算的规则也不同,这里的price得到的值左移了8位
        // 大约是 300000000000 也就是3000.00000000
        // msg.value 是有18位小数的1eth=100000000000000000wei
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
        );
        (, int256 price, , , ) = priceFeed.latestRoundData();
        // 前面左移了8位，这里再左移10位将单位换算成wei了
        return uint256(price * 1e10);
    }

    // 将以太币转成usd;

    function getConversionRate(
        uint256 ethAmount
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice();
        // 为了不损失精度，solidity中不使用小数，通过约定后面补充几位0来表示小数
        // 因为以太币wei通常有18位，所以通常需要将其他地方的来的数据补上18位，getPrice就是这样
        // ethPrice 与 ethAmount都左移了18位，相乘或者相除时候结果要再除以18位小数不然会
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}

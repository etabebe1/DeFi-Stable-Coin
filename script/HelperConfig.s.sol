// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    // 0x694AA1769357215DE4FAC081bf1f309aDC325306 ETH/USD
    // 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43 BTC/USD

    struct NetworkConfig {
        address wBTC_USDPriceFeed;
        address wETH_USDPriceFeed;
        address wBTC;
        address wETH;
        uint256 deployKey;
    }

    NetworkConfig public activeNetwork;
    mapping(uint256 chainId => NetworkConfig) chainIdToNetworkConfig;

    /// Private and Internal vew functions ///
    function _initializeHelperConfig() internal {}

    function _setActiveNetworkConfig() internal {}
}

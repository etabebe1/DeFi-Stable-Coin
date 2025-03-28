// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {DSCEngine} from "../src/DSCEngine.sol";
import {DeFiStableCoin} from "../src/DeFiStableCoin.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract DeployDSC is Script {
    address[] collateralTokenAddresses;
    address[] priceFeedTokenAddresses;

    function run() external returns (DSCEngine, DeFiStableCoin, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();

        console.log("Run deploy script");
    }
}

//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//

// import {Script} from "forge-std/Script.sol";
// import {DeFiStableCoin} from "../src/DeFiStableCoin.sol";
// import {DSCEngine} from "../src/DSCEngine.sol";
// import {HelperConfig} from "./HelperConfig.s.sol";

// contract DeployDSC is Script {
//     address[] collateralTokenAddresses;
//     address[] priceFeedTokenAddresses;

//     function run() external returns (DeFiStableCoin, DSCEngine, HelperConfig) {
//         HelperConfig helperConfig = new HelperConfig();

//         (address wBTC_USDPriceFeed, address wETH_USDPriceFeed, address wBTC, address wETH,) =
//             helperConfig.activeNetworkConfig();

//         collateralTokenAddresses = [wBTC_USDPriceFeed, wETH_USDPriceFeed];
//         priceFeedTokenAddresses = [wBTC, wETH];

//         vm.startBroadcast();
//         DeFiStableCoin dsc = new DeFiStableCoin();
//         DSCEngine dscEngine = new DSCEngine(collateralTokenAddresses, priceFeedTokenAddresses, address(dsc));

//         dsc.transferOwnership(address(dsc));
//         vm.stopBroadcast();

//         return (dsc, dscEngine, helperConfig);
//     }
// }

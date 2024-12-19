// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.26;

import {Script} from "forge-std/Script.sol";
import {DeFiStableCoin} from "../src/DeFiStableCoin.sol";
import {DSCEngine} from "../src/DSCEngine.sol";

contract DeployDSC is Script {
    function run() external returns (DeFiStableCoin, DSCEngine) {
        vm.startBroadcast();
        DeFiStableCoin dsc = new DeFiStableCoin();
        address dscAddress = address(dsc);
        // DSCEngine dscEngin = new DSCEngine(dscAddress);
        vm.stopBroadcast();
    }
}

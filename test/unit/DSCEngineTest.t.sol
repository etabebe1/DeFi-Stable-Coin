// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {DeployDSC} from "../../script/DeployDSC.s.sol";
import {DSCEngine} from "../../src/DSCEngine.sol";
import {DeFiStableCoin} from "../../src/DeFiStableCoin.sol";

contract DSCEngineTest is Test {
    DeployDSC deployer;
    DeFiStableCoin dsc;
    DSCEngine dscEngine;

    function setUp() external {
        deployer = new DeployDSC();
        (dsc, dscEngine) = deployer.run();
    }
}

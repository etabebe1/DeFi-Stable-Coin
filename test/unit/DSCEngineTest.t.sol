// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {DeployDSC} from "../../script/DeployDSC.s.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {DSCEngine} from "../../src/DSCEngine.sol";
import {DeFiStableCoin} from "../../src/DeFiStableCoin.sol";

contract DSCEngineTest is Test {
    DeployDSC deployer;
    // HelperConfig helperConfig;
    // DeFiStableCoin dsc;
    // DSCEngine dscEngine;
    // address wETH_USDPriceFeed;
    // address wETH;

    //* to test using this command, you need to write a test function
    //* forge test --match-path test/unit/DSCEngineTest.t.sol -vv

    // function setUp() external {
    //     deployer = new DeployDSC();
    //     (dsc, dscEngine, helperConfig) = deployer.run();

    //     (, wETH_USDPriceFeed,, wETH,) = helperConfig.activeNetworkConfig();
    // }

    // function testGetUSDValue() public view {
    //     uint256 ethAmount = 15e18;
    //     uint256 expectedInUSD = 30000e18;
    //     uint256 actualInUSD = dscEngine.getUSDValue(wETH, ethAmount);

    //     assertEq(expectedInUSD, actualInUSD);
    // }
}

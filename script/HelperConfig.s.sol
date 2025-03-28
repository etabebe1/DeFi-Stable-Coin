// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

abstract contract HelperConfigConstants {
    uint256 ETH_SEPOLIA_CHAIN_ID = 11155111;
    uint256 ETH_ANVIL_CHAIN_ID = 31337;

    uint8 public constant DECIMALS = 8;
    int256 public constant ETH_USD_PRICE = 2000e8;
    int256 public constant BTC_USD_PRICE = 1000e8;
    uint256 public constant DEFAULT_ANVIL_PRIVATE_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d;
}

contract HelperConfig is Script, HelperConfigConstants {
    error HelperConfig_InvalidChainId();

    struct NetworkConfig {
        address wBTC_USDPriceFeed;
        address wETH_USDPriceFeed;
        address wBTC;
        address wETH;
        uint256 deployKey;
    }

    NetworkConfig public activeNetworkConfig;
    mapping(uint256 => NetworkConfig) public chainIdToNetworkConfig;

    constructor() {
        _initializeHelperConfig();
        _handleAnvilChian();
        _setActiveNetwork();
    }

    function _initializeHelperConfig() internal {
        // Sepolia network config
        chainIdToNetworkConfig[ETH_SEPOLIA_CHAIN_ID] = NetworkConfig({
            wBTC_USDPriceFeed: 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43,
            wETH_USDPriceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306,
            wBTC: 0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063,
            wETH: 0xdd13E55209Fd76AfE204dBda4007C227904f0a81,
            deployKey: vm.envUint("PRIVATE_KEY")
        });

        // Local Anvil Configuration
        chainIdToNetworkConfig[ETH_ANVIL_CHAIN_ID] = NetworkConfig({
            wBTC_USDPriceFeed: address(0),
            wETH_USDPriceFeed: address(0),
            wBTC: address(0),
            wETH: address(0),
            deployKey: DEFAULT_ANVIL_PRIVATE_KEY
        });
    }

    function _handleAnvilChian() internal returns (NetworkConfig memory) {
        vm.startBroadcast();
        MockV3Aggregator ethMockV3Aggregator = new MockV3Aggregator(DECIMALS, ETH_USD_PRICE);
        ERC20Mock wETHMock = new ERC20Mock();

        MockV3Aggregator btcMockV3Aggregator = new MockV3Aggregator(DECIMALS, BTC_USD_PRICE);
        ERC20Mock wBTCMock = new ERC20Mock();
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            wBTC_USDPriceFeed: address(btcMockV3Aggregator),
            wETH_USDPriceFeed: address(ethMockV3Aggregator),
            wBTC: address(wBTCMock),
            wETH: address(wETHMock),
            deployKey: DEFAULT_ANVIL_PRIVATE_KEY
        });

        // Update the mapping for Anvil chain ID
        anvilConfig = chainIdToNetworkConfig[ETH_ANVIL_CHAIN_ID];
        return anvilConfig;
    }

    function _setActiveNetwork() internal returns (NetworkConfig memory) {
        uint256 currentChainId = block.chainid;

        if (currentChainId == ETH_ANVIL_CHAIN_ID) {
            activeNetworkConfig = _handleAnvilChian();
        } else if (chainIdToNetworkConfig[currentChainId].wBTC_USDPriceFeed != address(0)) {
            activeNetworkConfig = chainIdToNetworkConfig[currentChainId];
        } else {
            revert HelperConfig_InvalidChainId();
        }

        return activeNetworkConfig;
    }
}

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.26;

/**
 * @title
 * @author
 * @notice
 *
 * The system is designed to be as minimal as possible, and have the tokens maintain a 1 token == $1 peg at all times.
 * This is a stablecoin with the properties:
 * - Exogenously Collateralized
 * - Dollar Pegged
 * - Algorithmically Stable
 *
 * It is similar to DAI if DAI had no governance, no fees, and was backed by only WETH and WBTC.
 *
 * Our DSC system should always be "overcollateralized". At no point, should the value of
 * all collateral < the $ backed value of all the DSC.
 *
 * @notice This contract is the core of the DeFi StableCoin system. It handles all the logic
 * for minting and redeeming DSC, as well as depositing and withdrawing collateral.
 * @notice This contract is based on the MakerDAO DSS system
 */
import {DeFiStableCoin} from "./DeFiStableCoin.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract DSCEngine is ReentrancyGuard {
    // ** errors
    error DSCEngine__valueShouldBeGreaterThanZero();
    error DSCEngine__tokenAddressAndPriceFeedAddressesLengthUnmatched();
    error DSCEngine__tokenNotAllowed();

    // ** state variables
    DeFiStableCoin private immutable i_dsc;
    mapping(address collateralToken => address priceFeed)
        private s_tokenToPriceFeed; // s_tokenToPriceFeed

    // ** modifiers
    modifier shouldBeGreaterThanZero(uint256 _amount) {
        if (_amount <= 0) {
            revert DSCEngine__valueShouldBeGreaterThanZero();
        }
        _;
    }

    modifier isAllowedToken(address token) {
        if (s_tokenToPriceFeed[token] == address(0)) {
            revert DSCEngine__tokenNotAllowed();
        }
        _;
    }

    // **functions
    constructor(
        address[] memory tokenAddresses,
        address[] memory priceFeedAddresses,
        address _dsc
    ) {
        if (tokenAddresses.length != priceFeedAddresses.length) {
            revert DSCEngine__tokenAddressAndPriceFeedAddressesLengthUnmatched();
        }

        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            s_tokenToPriceFeed[tokenAddresses[i]] = priceFeedAddresses[i];
        }

        i_dsc = DeFiStableCoin(_dsc);
    }

    // ** external function
    function depositCollateralAndMintDsc() external {}

    /**
     * @param tokenCollateralAddress - address of collateral
     * @param collateralAmount - amount of collateral that would be deposited
     */
    function depositCollateral(
        address tokenCollateralAddress,
        uint256 collateralAmount
    )
        external
        shouldBeGreaterThanZero(collateralAmount)
        isAllowedToken(tokenCollateralAddress)
        nonReentrant
    {}

    function redeemCollateralForDsc() external {}

    function redeemCollateral() external {}

    function mintDsc() external {}

    function burnDsc() external {}

    function liquidate() external {}

    function getHealthFactor() external view {}
}

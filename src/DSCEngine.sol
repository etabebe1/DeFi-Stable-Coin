// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.26;

/**
 * @title DSCEngine || DeFiStableCoinEngine
 * @author Jeremiah A.
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
 * Our DSC system should always be "overollateralized". At no point, should the value of
 * all collateral < the $ backed value of all the DSC.
 *
 * @notice This contract is the core of the DeFi StableCoin system. It handles all the logic
 * for minting and redeeming DSC, as well as depositing and withdrawing collateral.
 * @notice This contract is based on the MakerDAO DSS system
 */
import {DeFiStableCoin} from "./DeFiStableCoin.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {AggregatorV3Interface} from
    "../lib/chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract DSCEngine is ReentrancyGuard {
    /// errors ///
    error DSCEngine__valueShouldBeGreaterThanZero();
    error DSCEngine__tokenAddressAndPriceFeedAddressesLengthUnmatched();
    error DSCEngine__tokenNotAllowed();
    error DSCEngine__depositCollateralFailed();

    /// state variables ///
    DeFiStableCoin private immutable i_dsc;

    /// @dev Mapping collateral token to priceFeed address
    mapping(address collateralToken => address priceFeed) private s_collateralTokenToPriceFeed;
    /// @dev Amount of collateral deposited by user
    //      |--CollateralTokenAddress(wEth, wBTC)
    // user-|
    //      |--Amount of collateral
    mapping(address user => mapping(address collateralToken => uint256 amount)) private s_collateralDeposited;

    /// @dev Mapping user address to amount of DSC they minted/created
    mapping(address user => uint256 amount) private s_DSCMinted;
    /// @dev If we know exactly how many tokens we have, we could make this immutable!
    address[] private s_collateralTokens;

    /// events
    event CollateralDeposited(address indexed user, address indexed token, uint256 indexed amount);

    /// modifiers ///
    modifier shouldBeGreaterThanZero(uint256 _amount) {
        if (_amount <= 0) {
            revert DSCEngine__valueShouldBeGreaterThanZero();
        }
        _;
    }

    modifier isAllowedCollateralToken(address collateralTokenAddress) {
        if (s_collateralTokenToPriceFeed[collateralTokenAddress] == address(0)) {
            revert DSCEngine__tokenNotAllowed();
        }
        _;
    }

    /// functions ///
    /**
     * @param collateralTokenAddresses - an array of addresses used for collateral(wETH or wBTC)
     * @param priceFeedAddresses - an array of addresses used for getting the value of collaterals. These price feed addresses will be obtained form Chainlink's price feed
     * @param _dsc - address of DeFiStableCoin
     */
    constructor(address[] memory collateralTokenAddresses, address[] memory priceFeedAddresses, address _dsc) {
        if (collateralTokenAddresses.length != priceFeedAddresses.length) {
            revert DSCEngine__tokenAddressAndPriceFeedAddressesLengthUnmatched();
        }

        for (uint256 i = 0; i < collateralTokenAddresses.length; i++) {
            s_collateralTokenToPriceFeed[collateralTokenAddresses[i]] = priceFeedAddresses[i];
        }

        i_dsc = DeFiStableCoin(_dsc);
    }

    /// external function ///
    function depositCollateralAndMintDsc() external {}

    /**
     * @notice function bellow following CEI
     * @param collateralTokenAddress - address of collateral used to borrow DSC
     * @param collateralAmount - amount of collateral that would be deposited
     */
    function depositCollateral(address collateralTokenAddress, uint256 collateralAmount)
        external
        shouldBeGreaterThanZero(collateralAmount)
        isAllowedCollateralToken(collateralTokenAddress)
        nonReentrant
    {
        s_collateralDeposited[msg.sender][collateralTokenAddress] = collateralAmount;
        emit CollateralDeposited(msg.sender, collateralTokenAddress, collateralAmount);
        bool success = IERC20(collateralTokenAddress).transferFrom(msg.sender, address(this), collateralAmount);

        if (!success) {
            revert DSCEngine__depositCollateralFailed();
        }
    }

    function redeemCollateralForDsc() external {}

    function redeemCollateral() external {}

    function mintDsc() external {}

    function burnDsc() external {}

    function liquidate() external {}

    function getHealthFactor() external view {}

    /// Private and Internal vew functions ///

    function _getAccountInfo(address _user)
        private
        view
        returns (uint256 totalDSCMinted, uint256 collateralValueInUSD)
    {
        totalDSCMinted = s_DSCMinted[_user];
        collateralValueInUSD = getAccountCollateralValue(_user);
    }

    /**
     * Returns how close to liquidation a user is
     * If a user Hf goes bellow 1 user would be liquidated
     */
    function _healthFactor(address user) internal returns (uint256) {
        (uint256 totalDSCMinted, uint256 collateralValueInUSD) = _getAccountInfo(user);
    }

    /**
     * @notice function bellow following CEI
     * Checks health factor (if user have enough collateral)
     * If not it reverts
     */
    function _revertIfHealthFactorIsBroken(address user) internal view {}

    /// Public and External vew functions ///

    /**
     * @dev loop through each collateral token, get the amount they have deposited, and map it to
     * the price, to get the USD value
     */
    function getAccountCollateralValue(address user) public view returns (uint256 totalCollateralValueInUSD) {
        for (uint256 i = 0; i < s_collateralTokens.length; i++) {
            address token = s_collateralTokens[i];
            uint256 amount = s_collateralDeposited[user][token];
            totalCollateralValueInUSD += getUSDValue(token, amount);
        }
        return totalCollateralValueInUSD;
    }

    function getUSDValue(address token, uint256 amount) public view returns (uint256) {}
}

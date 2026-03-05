```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";

/**
 * @title Liquidity Pool Optimization Contract
 * @author [Your Name]
 * @notice This contract is designed to optimize liquidity pools by providing a mechanism for liquidity providers to add and remove liquidity.
 * @dev This contract uses the OpenZeppelin library for access control, reentrancy protection, and ERC20 token handling.
 */
contract LiquidityPoolOptimization is Ownable, ReentrancyGuard {
    /**
     * @dev Custom error for when the liquidity pool is not initialized.
     */
    error LiquidityPoolNotInitialized();

    /**
     * @dev Custom error for when the liquidity provider is not authorized.
     */
    error UnauthorizedLiquidityProvider();

    /**
     * @dev Custom error for when the liquidity amount is invalid.
     */
    error InvalidLiquidityAmount();

    /**
     * @dev Custom error for when the token amount is invalid.
     */
    error InvalidTokenAmount();

    /**
     * @dev Event emitted when liquidity is added to the pool.
     * @param provider The address of the liquidity provider.
     * @param amount The amount of liquidity added.
     */
    event LiquidityAdded(address indexed provider, uint256 amount);

    /**
     * @dev Event emitted when liquidity is removed from the pool.
     * @param provider The address of the liquidity provider.
     * @param amount The amount of liquidity removed.
     */
    event LiquidityRemoved(address indexed provider, uint256 amount);

    /**
     * @dev Event emitted when the liquidity pool is initialized.
     * @param token The address of the token used in the liquidity pool.
     * @param liquidity The initial liquidity of the pool.
     */
    event LiquidityPoolInitialized(address indexed token, uint256 liquidity);

    /**
     * @dev The address of the token used in the liquidity pool.
     */
    address public token;

    /**
     * @dev The current liquidity of the pool.
     */
    uint256 public liquidity;

    /**
     * @dev Mapping of liquidity providers to their respective liquidity amounts.
     */
    mapping(address => uint256) public liquidityProviders;

    /**
     * @dev Initializes the liquidity pool with the specified token and initial liquidity.
     * @param _token The address of the token used in the liquidity pool.
     * @param _liquidity The initial liquidity of the pool.
     */
    function initialize(address _token, uint256 _liquidity) public onlyOwner {
        if (token != address(0)) {
            revert LiquidityPoolNotInitialized();
        }

        token = _token;
        liquidity = _liquidity;

        emit LiquidityPoolInitialized(_token, _liquidity);
    }

    /**
     * @dev Adds liquidity to the pool.
     * @param _amount The amount of liquidity to add.
     */
    function addLiquidity(uint256 _amount) public nonReentrant {
        if (token == address(0)) {
            revert LiquidityPoolNotInitialized();
        }

        if (_amount == 0) {
            revert InvalidLiquidityAmount();
        }

        IERC20(token).transferFrom(msg.sender, address(this), _amount);

        liquidity += _amount;
        liquidityProviders[msg.sender] += _amount;

        emit LiquidityAdded(msg.sender, _amount);
    }

    /**
     * @dev Removes liquidity from the pool.
     * @param _amount The amount of liquidity to remove.
     */
    function removeLiquidity(uint256 _amount) public nonReentrant {
        if (token == address(0)) {
            revert LiquidityPoolNotInitialized();
        }

        if (_amount == 0) {
            revert InvalidLiquidityAmount();
        }

        if (liquidityProviders[msg.sender] < _amount) {
            revert UnauthorizedLiquidityProvider();
        }

        IERC20(token).transfer(msg.sender, _amount);

        liquidity -= _amount;
        liquidityProviders[msg.sender] -= _amount;

        emit LiquidityRemoved(msg.sender, _amount);
    }

    /**
     * @dev Returns the current liquidity of the pool.
     * @return The current liquidity of the pool.
     */
    function getLiquidity() public view returns (uint256) {
        return liquidity;
    }

    /**
     * @dev Returns the liquidity amount of the specified liquidity provider.
     * @param _provider The address of the liquidity provider.
     * @return The liquidity amount of the specified liquidity provider.
     */
    function getLiquidityProvider(address _provider) public view returns (uint256) {
        return liquidityProviders[_provider];
    }
}

/**
 * @notice README
 * 
 * This contract is designed to optimize liquidity pools by providing a mechanism for liquidity providers to add and remove liquidity.
 * 
 * To deploy this contract, follow these steps:
 * 1. Compile the contract using the Solidity compiler.
 * 2. Deploy the contract to the Ethereum network using a deployment tool such as Truffle or Hardhat.
 * 3. Initialize the liquidity pool by calling the `initialize` function with the address of the token used in the liquidity pool and the initial liquidity.
 * 4. Add liquidity to the pool by calling the `addLiquidity` function with the amount of liquidity to add.
 * 5. Remove liquidity from the pool by calling the `removeLiquidity` function with the amount of liquidity to remove.
 * 
 * Note: This contract uses the OpenZeppelin library for access control, reentrancy protection, and ERC20 token handling. It is recommended to use a secure deployment tool and to thoroughly test the contract before deploying it to the mainnet.
 */
```
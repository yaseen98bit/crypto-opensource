```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title Liquidity Pool Optimization Contract
 * @author [Your Name]
 * @notice This contract is designed to optimize liquidity pools by providing a mechanism for users to add and remove liquidity.
 * @dev This contract uses OpenZeppelin's Ownable and ReentrancyGuard contracts for access control and reentrancy protection.
 */
contract LiquidityPoolOptimization is Ownable, ReentrancyGuard {
    /**
     * @notice Custom error for when the liquidity pool is empty.
     */
    error LiquidityPoolIsEmpty();

    /**
     * @notice Custom error for when the user does not have sufficient balance.
     */
    error InsufficientBalance();

    /**
     * @notice Custom error for when the user tries to add zero liquidity.
     */
    error CannotAddZeroLiquidity();

    /**
     * @notice Custom error for when the user tries to remove zero liquidity.
     */
    error CannotRemoveZeroLiquidity();

    /**
     * @notice Event emitted when liquidity is added to the pool.
     * @param user The address of the user who added liquidity.
     * @param amount The amount of liquidity added.
     */
    event LiquidityAdded(address indexed user, uint256 amount);

    /**
     * @notice Event emitted when liquidity is removed from the pool.
     * @param user The address of the user who removed liquidity.
     * @param amount The amount of liquidity removed.
     */
    event LiquidityRemoved(address indexed user, uint256 amount);

    /**
     * @notice Event emitted when the liquidity pool is updated.
     * @param totalLiquidity The new total liquidity in the pool.
     */
    event LiquidityPoolUpdated(uint256 totalLiquidity);

    /**
     * @notice The token used for liquidity.
     */
    IERC20 public token;

    /**
     * @notice The total liquidity in the pool.
     */
    uint256 public totalLiquidity;

    /**
     * @notice Mapping of user to their liquidity balance.
     */
    mapping(address => uint256) public userLiquidity;

    /**
     * @notice Constructor for the contract.
     * @param _token The address of the token used for liquidity.
     */
    constructor(IERC20 _token) {
        token = _token;
    }

    /**
     * @notice Function to add liquidity to the pool.
     * @param amount The amount of liquidity to add.
     */
    function addLiquidity(uint256 amount) public nonReentrant {
        if (amount == 0) {
            revert CannotAddZeroLiquidity();
        }

        if (token.balanceOf(msg.sender) < amount) {
            revert InsufficientBalance();
        }

        SafeERC20.safeTransferFrom(token, msg.sender, address(this), amount);
        userLiquidity[msg.sender] += amount;
        totalLiquidity += amount;

        emit LiquidityAdded(msg.sender, amount);
        emit LiquidityPoolUpdated(totalLiquidity);
    }

    /**
     * @notice Function to remove liquidity from the pool.
     * @param amount The amount of liquidity to remove.
     */
    function removeLiquidity(uint256 amount) public nonReentrant {
        if (amount == 0) {
            revert CannotRemoveZeroLiquidity();
        }

        if (userLiquidity[msg.sender] < amount) {
            revert InsufficientBalance();
        }

        if (totalLiquidity < amount) {
            revert LiquidityPoolIsEmpty();
        }

        userLiquidity[msg.sender] -= amount;
        totalLiquidity -= amount;

        SafeERC20.safeTransfer(token, msg.sender, amount);

        emit LiquidityRemoved(msg.sender, amount);
        emit LiquidityPoolUpdated(totalLiquidity);
    }

    /**
     * @notice Function to get the user's liquidity balance.
     * @param user The address of the user.
     * @return The user's liquidity balance.
     */
    function getUserLiquidity(address user) public view returns (uint256) {
        return userLiquidity[user];
    }

    /**
     * @notice Function to get the total liquidity in the pool.
     * @return The total liquidity in the pool.
     */
    function getTotalLiquidity() public view returns (uint256) {
        return totalLiquidity;
    }
}

/**
 * @notice README
 * This contract is designed to optimize liquidity pools by providing a mechanism for users to add and remove liquidity.
 * The contract uses OpenZeppelin's Ownable and ReentrancyGuard contracts for access control and reentrancy protection.
 * The contract has custom errors for when the liquidity pool is empty, the user does not have sufficient balance, and when the user tries to add or remove zero liquidity.
 * The contract emits events when liquidity is added or removed, and when the liquidity pool is updated.
 * The contract has functions to add and remove liquidity, get the user's liquidity balance, and get the total liquidity in the pool.
 * The contract is designed to be deployed on the Ethereum blockchain and can be used with any ERC20 token.
 */
```
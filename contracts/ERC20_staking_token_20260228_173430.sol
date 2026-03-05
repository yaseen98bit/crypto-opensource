**ERC20 Staking Token Contract**
=====================================

### Contract Code
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.8.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.8.0/contracts/access/AccessControl.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.8.0/contracts/security/ReentrancyGuard.sol";

/**
 * @title ERC20 Staking Token
 * @author Yaseen
 * @notice This contract implements an ERC20 staking token with access control and reentrancy protection.
 */
contract ERC20StakingToken is ERC20, AccessControl, ReentrancyGuard {
    // Events
    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event RewardsClaimed(address indexed user, uint256 amount);

    // Roles
    bytes32 public constant STAKER_ROLE = keccak256("STAKER_ROLE");
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    // Staking variables
    mapping(address => uint256) public stakingBalances;
    mapping(address => uint256) public stakingRewards;
    uint256 public totalStaked;

    /**
     * @notice Initializes the contract with the given name, symbol, and decimals.
     * @param name The name of the token.
     * @param symbol The symbol of the token.
     * @param decimals The number of decimals for the token.
     */
    constructor(string memory name, string memory symbol, uint8 decimals) ERC20(name, symbol) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(ADMIN_ROLE, msg.sender);
    }

    /**
     * @notice Stakes the given amount of tokens.
     * @param amount The amount of tokens to stake.
     */
    function stake(uint256 amount) external nonReentrant {
        require(amount > 0, "Amount must be greater than 0");
        require(hasRole(STAKER_ROLE, msg.sender), "Only stakers can call this function");

        // Update staking balance and total staked
        stakingBalances[msg.sender] += amount;
        totalStaked += amount;

        // Burn tokens
        _burn(msg.sender, amount);

        emit Staked(msg.sender, amount);
    }

    /**
     * @notice Unstakes the given amount of tokens.
     * @param amount The amount of tokens to unstake.
     */
    function unstake(uint256 amount) external nonReentrant {
        require(amount > 0, "Amount must be greater than 0");
        require(stakingBalances[msg.sender] >= amount, "Insufficient staked balance");

        // Update staking balance and total staked
        stakingBalances[msg.sender] -= amount;
        totalStaked -= amount;

        // Mint tokens
        _mint(msg.sender, amount);

        emit Unstaked(msg.sender, amount);
    }

    /**
     * @notice Claims rewards for the staker.
     */
    function claimRewards() external nonReentrant {
        require(stakingRewards[msg.sender] > 0, "No rewards available");

        // Update staking rewards
        uint256 rewards = stakingRewards[msg.sender];
        stakingRewards[msg.sender] = 0;

        // Mint tokens
        _mint(msg.sender, rewards);

        emit RewardsClaimed(msg.sender, rewards);
    }

    /**
     * @notice Updates the staking rewards for the given user.
     * @param user The user to update rewards for.
     * @param rewards The new rewards amount.
     */
    function updateStakingRewards(address user, uint256 rewards) external onlyRole(ADMIN_ROLE) {
        stakingRewards[user] = rewards;
    }
}
```

### Deployment Steps

1. **Install Truffle Suite**:
```bash
npm install -g truffle
```
2. **Create a new Truffle project**:
```bash
truffle init
```
3. **Create a new file for the contract**:
```bash
touch contracts/ERC20StakingToken.sol
```
4. **Copy the contract code into the file**:
```bash
nano contracts/ERC20StakingToken.sol
```
5. **Compile the contract**:
```bash
truffle compile
```
6. **Deploy the contract to a network** (e.g. Ethereum Mainnet, Ropsten Testnet):
```bash
truffle migrate --network mainnet
```
7. **Verify the contract on Etherscan** (optional):
```bash
truffle run verify --network mainnet
```

### Example Usage
```solidity
// Stake 100 tokens
token.stake(100);

// Unstake 50 tokens
token.unstake(50);

// Claim rewards
token.claimRewards();

// Update staking rewards for a user (only admin)
token.updateStakingRewards(userAddress, 100);
```
Note: This is a basic example and you should always use a secure and tested deployment process in production.
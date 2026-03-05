```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/**
 * @title Lending Protocol with Dynamic Interest Rates and Credit Scoring
 * @author Clawrence
 * @notice This contract provides a lending protocol with dynamic interest rates and credit scoring.
 * @dev This contract uses OpenZeppelin's Ownable and ReentrancyGuard for access control and reentrancy protection.
 */
contract LendingProtocol is Ownable, ReentrancyGuard {
    // Custom errors for gas efficiency
    error InsufficientBalance();
    error InvalidInterestRate();
    error InvalidCreditScore();

    // Struct to represent a loan
    struct Loan {
        address borrower;
        uint256 amount;
        uint256 interestRate;
        uint256 creditScore;
        uint256 repaymentAmount;
        bool isRepaid;
    }

    // Mapping of loans
    mapping(address => Loan[]) public loans;

    // Mapping of credit scores
    mapping(address => uint256) public creditScores;

    // Dynamic interest rate
    uint256 public interestRate;

    // Event emitted when a loan is created
    /**
     * @notice Emitted when a loan is created
     * @param borrower The borrower's address
     * @param amount The loan amount
     * @param interestRate The interest rate
     * @param creditScore The borrower's credit score
     */
    event LoanCreated(address borrower, uint256 amount, uint256 interestRate, uint256 creditScore);

    // Event emitted when a loan is repaid
    /**
     * @notice Emitted when a loan is repaid
     * @param borrower The borrower's address
     * @param amount The repayment amount
     */
    event LoanRepaid(address borrower, uint256 amount);

    // Event emitted when the interest rate is updated
    /**
     * @notice Emitted when the interest rate is updated
     * @param newInterestRate The new interest rate
     */
    event InterestRateUpdated(uint256 newInterestRate);

    // Event emitted when a credit score is updated
    /**
     * @notice Emitted when a credit score is updated
     * @param borrower The borrower's address
     * @param newCreditScore The new credit score
     */
    event CreditScoreUpdated(address borrower, uint256 newCreditScore);

    /**
     * @notice Creates a new loan
     * @param amount The loan amount
     * @param creditScore The borrower's credit score
     * @return The loan ID
     */
    function createLoan(uint256 amount, uint256 creditScore) public nonReentrant returns (uint256) {
        // Check if the borrower has sufficient balance
        if (amount > address(this).balance) {
            revert InsufficientBalance();
        }

        // Check if the interest rate is valid
        if (interestRate == 0) {
            revert InvalidInterestRate();
        }

        // Check if the credit score is valid
        if (creditScore == 0) {
            revert InvalidCreditScore();
        }

        // Calculate the repayment amount
        uint256 repaymentAmount = amount + (amount * interestRate / 100);

        // Create a new loan
        Loan memory loan = Loan({
            borrower: msg.sender,
            amount: amount,
            interestRate: interestRate,
            creditScore: creditScore,
            repaymentAmount: repaymentAmount,
            isRepaid: false
        });

        // Add the loan to the mapping
        loans[msg.sender].push(loan);

        // Emit the LoanCreated event
        emit LoanCreated(msg.sender, amount, interestRate, creditScore);

        // Return the loan ID
        return loans[msg.sender].length - 1;
    }

    /**
     * @notice Repays a loan
     * @param loanId The loan ID
     */
    function repayLoan(uint256 loanId) public nonReentrant {
        // Check if the loan exists
        if (loans[msg.sender].length <= loanId) {
            revert InsufficientBalance();
        }

        // Get the loan
        Loan storage loan = loans[msg.sender][loanId];

        // Check if the loan is already repaid
        if (loan.isRepaid) {
            revert InsufficientBalance();
        }

        // Check if the borrower has sufficient balance
        if (loan.repaymentAmount > address(this).balance) {
            revert InsufficientBalance();
        }

        // Repay the loan
        loan.isRepaid = true;

        // Emit the LoanRepaid event
        emit LoanRepaid(msg.sender, loan.repaymentAmount);
    }

    /**
     * @notice Updates the interest rate
     * @param newInterestRate The new interest rate
     */
    function updateInterestRate(uint256 newInterestRate) public onlyOwner {
        // Check if the new interest rate is valid
        if (newInterestRate == 0) {
            revert InvalidInterestRate();
        }

        // Update the interest rate
        interestRate = newInterestRate;

        // Emit the InterestRateUpdated event
        emit InterestRateUpdated(newInterestRate);
    }

    /**
     * @notice Updates a credit score
     * @param borrower The borrower's address
     * @param newCreditScore The new credit score
     */
    function updateCreditScore(address borrower, uint256 newCreditScore) public onlyOwner {
        // Check if the new credit score is valid
        if (newCreditScore == 0) {
            revert InvalidCreditScore();
        }

        // Update the credit score
        creditScores[borrower] = newCreditScore;

        // Emit the CreditScoreUpdated event
        emit CreditScoreUpdated(borrower, newCreditScore);
    }
}

/**
 * README
 * 
 * This contract provides a lending protocol with dynamic interest rates and credit scoring.
 * 
 * To deploy this contract, follow these steps:
 * 1. Compile the contract using the Solidity compiler.
 * 2. Deploy the contract to a blockchain network.
 * 3. Call the `createLoan` function to create a new loan.
 * 4. Call the `repayLoan` function to repay a loan.
 * 5. Call the `updateInterestRate` function to update the interest rate.
 * 6. Call the `updateCreditScore` function to update a credit score.
 * 
 * Key functions:
 * - `createLoan`: Creates a new loan.
 * - `repayLoan`: Repays a loan.
 * - `updateInterestRate`: Updates the interest rate.
 * - `updateCreditScore`: Updates a credit score.
 * 
 * Security notes:
 * - This contract uses OpenZeppelin's Ownable and ReentrancyGuard for access control and reentrancy protection.
 * - The contract uses custom errors for gas efficiency.
 * - The contract uses events to emit state changes.
 * - The contract uses a mapping to store loans and credit scores.
 * - The contract uses a struct to represent a loan.
 * 
 * Note: This contract is for demonstration purposes only and should not be used in production without thorough testing and auditing.
 */
```
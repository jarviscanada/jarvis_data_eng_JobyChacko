package org.example;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class BankAccount {

  private final String accountNumber;
  private String ownerName;
  private double balance;

  private List<Double> deposits = new ArrayList<>();
  private List<Double> withdrawals = new ArrayList<>();

  public BankAccount(String accountNumber, String ownerName, double balance) {
    if (accountNumber == null || ownerName == null || balance < 0) {
      throw new IllegalArgumentException("Invalid arguments");
    }
    this.accountNumber = accountNumber;
    this.ownerName = ownerName;
    this.balance = balance;
  }

  public void deposit(double amount) {
    if (amount <= 0) {
      throw new IllegalArgumentException("Deposit amount must be greater than 0.");
    }
    balance += amount;
    deposits.add(amount);
  }

  public void withdraw(double amount) {
    if (amount <= 0) {
      throw new IllegalArgumentException("Withdraw amount must be greater than 0.");
    }
    if (amount > balance) {
      throw new IllegalArgumentException("Withdraw amount must be less than or equal to balance.");
    }
    balance -= amount;
    withdrawals.add(amount);
  }

  // Total amount deposited
  public double getTotalDeposited() {
    return deposits.stream()
        .mapToDouble(Double::doubleValue)
        .sum();
  }

  // Total amount withdrawn
  public double getTotalWithdrawn() {
    return withdrawals.stream()
        .mapToDouble(Double::doubleValue)
        .sum();
  }

  // Largest transaction (deposit or withdrawal)
  public double getLargestTransaction() {

    double largestDeposit = deposits.stream()
        .mapToDouble(Double::doubleValue)
        .max()
        .orElse(0);

    double largestWithdrawal = withdrawals.stream()
        .mapToDouble(Double::doubleValue)
        .max()
        .orElse(0);

    return Math.max(largestDeposit, largestWithdrawal);
  }

  // List of all deposits
  public List<Double> getAllDeposits() {
    return deposits.stream()
        .collect(Collectors.toList());
  }

  // List of all transactions (deposits + withdrawals)
  public List<Double> getAllTransactions() {
    return Stream.concat(deposits.stream(), withdrawals.stream())
        .collect(Collectors.toList());
  }

  public String getAccountInfo() {
    return String.format(
        "Account: %s\nOwner: %s\nBalance: %.2f",
        accountNumber, ownerName, balance
    );
  }

  public String getAccountNumber() {
    return accountNumber;
  }

  public String getOwnerName() {
    return ownerName;
  }

  public double getBalance() {
    return balance;
  }
}
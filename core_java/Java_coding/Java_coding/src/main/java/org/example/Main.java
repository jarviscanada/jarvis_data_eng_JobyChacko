package org.example;

import java.util.Arrays;
import java.util.List;

public class Main {

  public static void main(String[] args) {
    List<Integer> transactions = Arrays.asList(20, 40, 5000, 30);
    int threshold = 1000;
    System.out.println("Suspicious Transactions: "+FraudDetector.detectFraud(transactions, threshold));
    BankAccount account = new BankAccount("123456", "John", 100);

    account.deposit(50);
    account.withdraw(30);

    System.out.println(account.getAccountInfo());

    System.out.println("Total Deposited: " + account.getTotalDeposited());
    System.out.println("Total Withdrawn: " + account.getTotalWithdrawn());
    System.out.println("Largest Transaction: " + account.getLargestTransaction());

    System.out.println("Deposits: " + account.getAllDeposits());
    System.out.println("All Transactions: " + account.getAllTransactions());
  }
}
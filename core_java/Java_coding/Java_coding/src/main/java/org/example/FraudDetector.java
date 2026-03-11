package org.example;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;


//public class FraudDetector {
//
//  public static List<Integer> detectFraud(List<Integer> transactions, int threshold) {
//    List<Integer> suspicious = new ArrayList<>();
//    for (int amount : transactions) {
//      if (amount > threshold) {
//        suspicious.add(amount);
//      }
//    }
//    return suspicious;
//  }
//}

//using stream

public class FraudDetector {

  public static List<Integer> detectFraud(List<Integer> transactions, int threshold) {
    return transactions.stream()
        .filter(amount -> amount > threshold)
        .collect(Collectors.toList());
  }
}






// To parse this JSON data, do
//
//     final buying = buyingFromJson(jsonString);

import 'dart:convert';

import 'md_Customer_get.dart';

Buying buyingFromJson(String str) => Buying.fromJson(json.decode(str));

String buyingToJson(Buying data) => json.encode(data.toJson());

class Buying {
    int bid;
    int customerId;
    String buyDateTime;
    int courseId;
    Customer customer;

    Buying({
        required this.bid,
        required this.customerId,
        required this.buyDateTime,
        required this.courseId,
        required this.customer,
    });

    factory Buying.fromJson(Map<String, dynamic> json) => Buying(
        bid: json["Bid"],
        customerId: json["CustomerID"],
        buyDateTime: json["BuyDateTime"],
        courseId: json["CourseID"],
        customer: Customer.fromJson(json["Customer"]),
    );

    Map<String, dynamic> toJson() => {
        "Bid": bid,
        "CustomerID": customerId,
        "BuyDateTime": buyDateTime,
        "CourseID": courseId,
        "Customer": customer.toJson(),
    };
}

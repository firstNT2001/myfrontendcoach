// To parse this JSON data, do
//
//     final buying = buyingFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'md_Customer_get.dart';
import 'md_coach_course_get.dart';

List<Buying> buyingFromJson(String str) => List<Buying>.from(json.decode(str).map((x) => Buying.fromJson(x)));

String buyingToJson(List<Buying> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Buying {
    int bid;
    int customerId;
    DateTime buyDateTime;
    int courseId;
    int originalId;
    int weight;
    Customer customer;
    Course course;

    Buying({
        required this.bid,
        required this.customerId,
        required this.buyDateTime,
        required this.courseId,
        required this.originalId,
        required this.weight,
        required this.customer,
        required this.course,
    });

    factory Buying.fromJson(Map<String, dynamic> json) => Buying(
        bid: json["Bid"],
        customerId: json["CustomerID"],
        buyDateTime: DateTime.parse(json["BuyDateTime"]),
        courseId: json["CourseID"],
        originalId: json["OriginalID"],
        weight: json["Weight"],
        customer: Customer.fromJson(json["Customer"]),
        course: Course.fromJson(json["Course"]),
    );

    Map<String, dynamic> toJson() => {
        "Bid": bid,
        "CustomerID": customerId,
        "BuyDateTime": buyDateTime.toIso8601String(),
        "CourseID": courseId,
        "OriginalID": originalId,
        "Weight": weight,
        "Customer": customer.toJson(),
        "Course": course.toJson(),
    };
}



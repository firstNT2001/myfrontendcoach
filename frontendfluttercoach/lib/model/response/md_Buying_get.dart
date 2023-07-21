// To parse this JSON data, do
//
//     final buying = buyingFromJson(jsonString);

import 'dart:convert';

import 'md_Customer_get.dart';
import 'md_coach_course_get.dart';

List<Buying> buyingFromJson(String str) => List<Buying>.from(json.decode(str).map((x) => Buying.fromJson(x)));

String buyingToJson(List<Buying> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Buying {
    int bid;
    int customerId;
    String buyDateTime;
    int courseId;
    Customer customer;
    Course course;

    Buying({
        required this.bid,
        required this.customerId,
        required this.buyDateTime,
        required this.courseId,
        required this.customer,
        required this.course,
    });

    factory Buying.fromJson(Map<String, dynamic> json) => Buying(
        bid: json["Bid"],
        customerId: json["CustomerID"],
        buyDateTime: json["BuyDateTime"],
        courseId: json["CourseID"],
        customer: Customer.fromJson(json["Customer"]),
        course: Course.fromJson(json["Course"]),
    );

    Map<String, dynamic> toJson() => {
        "Bid": bid,
        "CustomerID": customerId,
        "BuyDateTime": buyDateTime,
        "CourseID": courseId,
        "Customer": customer.toJson(),
        "Course": course.toJson(),
    };
}
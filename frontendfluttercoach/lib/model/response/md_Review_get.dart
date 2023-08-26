// To parse this JSON data, do
//
//     final modelReview = modelReviewFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'md_Customer_get.dart';

List<ModelReview> modelReviewFromJson(String str) => List<ModelReview>.from(json.decode(str).map((x) => ModelReview.fromJson(x)));

String modelReviewToJson(List<ModelReview> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelReview {
    int rid;
    int customerId;
    int courseId;
    String details;
    int score;
    int weight;
    Customer customer;

    ModelReview({
        required this.rid,
        required this.customerId,
        required this.courseId,
        required this.details,
        required this.score,
        required this.weight,
        required this.customer,
    });

    factory ModelReview.fromJson(Map<String, dynamic> json) => ModelReview(
        rid: json["Rid"],
        customerId: json["CustomerID"],
        courseId: json["CourseID"],
        details: json["Details"],
        score: json["Score"],
        weight: json["Weight"],
        customer: Customer.fromJson(json["Customer"]),
    );

    Map<String, dynamic> toJson() => {
        "Rid": rid,
        "CustomerID": customerId,
        "CourseID": courseId,
        "Details": details,
        "Score": score,
        "Weight": weight,
        "Customer": customer.toJson(),
    };
}


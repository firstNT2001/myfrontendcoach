// To parse this JSON data, do
//
//     final insertReview = insertReviewFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

InsertReview insertReviewFromJson(String str) =>
    InsertReview.fromJson(json.decode(str));

String insertReviewToJson(InsertReview data) => json.encode(data.toJson());

class InsertReview {
  int customerId;
  String details;
  int score;
  int weight;

  InsertReview({
    required this.customerId,
    required this.details,
    required this.score,
    required this.weight,
  });

  factory InsertReview.fromJson(Map<String, dynamic> json) => InsertReview(
        customerId: json["CustomerID"],
        details: json["Details"],
        score: json["Score"],
        weight: json["Weight"],
      );

  Map<String, dynamic> toJson() => {
        "CustomerID": customerId,
        "Details": details,
        "Score": score,
        "Weight": weight,
      };
}

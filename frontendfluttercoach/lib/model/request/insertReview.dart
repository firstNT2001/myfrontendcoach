// To parse this JSON data, do
//
//     final insertReview = insertReviewFromJson(jsonString);

import 'dart:convert';

InsertReview insertReviewFromJson(String str) => InsertReview.fromJson(json.decode(str));

String insertReviewToJson(InsertReview data) => json.encode(data.toJson());

class InsertReview {
    int courseId;
    String details;
    int score;
    int weight;

    InsertReview({
        required this.courseId,
        required this.details,
        required this.score,
        required this.weight,
    });

    factory InsertReview.fromJson(Map<String, dynamic> json) => InsertReview(
        courseId: json["CourseID"],
        details: json["Details"],
        score: json["Score"],
        weight: json["Weight"],
    );

    Map<String, dynamic> toJson() => {
        "CourseID": courseId,
        "Details": details,
        "Score": score,
        "Weight": weight,
    };
}

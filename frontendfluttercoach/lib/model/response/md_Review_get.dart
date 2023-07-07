// To parse this JSON data, do
//
//     final modelReview = modelReviewFromJson(jsonString);

import 'dart:convert';

import 'course_get_res.dart';
import 'md_Customer_get.dart';

List<ModelReview> modelReviewFromJson(String str) => List<ModelReview>.from(json.decode(str).map((x) => ModelReview.fromJson(x)));

String modelReviewToJson(List<ModelReview> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelReview {
    int rid;
    int uid;
    int coId;
    String details;
    int score;
    int weight;
    Customer customer;
    ModelCourse course;
    

    ModelReview({
        required this.rid,
        required this.uid,
        required this.coId,
        required this.details,
        required this.score,
        required this.weight,
        required this.customer,
        required this.course,
        
    });

    factory ModelReview.fromJson(Map<String, dynamic> json) => ModelReview(
        rid: json["Rid"],
        uid: json["CustomerID"],
        coId: json["CourseID"],
        details: json["Details"],
        score: json["Score"],
        weight: json["Weight"],
        customer: Customer.fromJson(json["Customer"]),
        course: ModelCourse.fromJson(json["Course"]),
        
    );

    Map<String, dynamic> toJson() => {
        "Rid": rid,
        "CustomerID": uid,
        "CourseID": coId,
        "Details": details,
        "Score": score,
        "Weight": weight,
        "Customer": customer.toJson(),
        "Course": course.toJson(),
    };
}



// To parse this JSON data, do
//
//     final modelReview = modelReviewFromJson(jsonString);

import 'package:frontendfluttercoach/model/modelCourse.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

import 'modelCoach.dart';
import 'modelCustomer.dart';

ModelReview modelReviewFromJson(String str) => ModelReview.fromJson(json.decode(str));

String modelReviewToJson(ModelReview data) => json.encode(data.toJson());

class ModelReview {
    ModelReview({
        required this.rid,
        required this.uid,
        required this.coId,
        required this.details,
        required this.score,
        required this.weight,
        required this.coach,
        required this.customer,
        required this.course,
    });

    int rid;
    int uid;
    int coId;
    String details;
    int score;
    int weight;
    Coach coach;
    Customer customer;
    ModelCourse course;

    factory ModelReview.fromJson(Map<String, dynamic> json) => ModelReview(
        rid: json["Rid"],
        uid: json["Uid"],
        coId: json["CoID"],
        details: json["Details"],
        score: json["Score"],
        weight: json["Weight"],
        coach: Coach.fromJson(json["Coach"]),
        customer: Customer.fromJson(json["Customer"]),
        course: ModelCourse.fromJson(json["Course"]),
    );

    Map<String, dynamic> toJson() => {
        "Rid": rid,
        "Uid": uid,
        "CoID": coId,
        "Details": details,
        "Score": score,
        "Weight": weight,
        "Coach": coach.toJson(),
        "Customer": customer.toJson(),
        "Course": course.toJson(),
    };
}

// To parse this JSON data, do
//
//     final updateCourse = updateCourseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UpdateCourse updateCourseFromJson(String str) => UpdateCourse.fromJson(json.decode(str));

String updateCourseToJson(UpdateCourse data) => json.encode(data.toJson());

class UpdateCourse {
    int coachId;
    String name;
    String details;
    String level;
    int amount;
    String image;
    int days;
    int price;
    String status;

    UpdateCourse({
        required this.coachId,
        required this.name,
        required this.details,
        required this.level,
        required this.amount,
        required this.image,
        required this.days,
        required this.price,
        required this.status,
    });

    factory UpdateCourse.fromJson(Map<String, dynamic> json) => UpdateCourse(
        coachId: json["CoachID"],
        name: json["Name"],
        details: json["Details"],
        level: json["Level"],
        amount: json["Amount"],
        image: json["Image"],
        days: json["Days"],
        price: json["Price"],
        status: json["Status"],
    );

    Map<String, dynamic> toJson() => {
        "CoachID": coachId,
        "Name": name,
        "Details": details,
        "Level": level,
        "Amount": amount,
        "Image": image,
        "Days": days,
        "Price": price,
        "Status": status,
    };
}

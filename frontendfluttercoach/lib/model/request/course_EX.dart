// To parse this JSON data, do
//
//     final courseExpiration = courseExpirationFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CourseExpiration courseExpirationFromJson(String str) => CourseExpiration.fromJson(json.decode(str));

String courseExpirationToJson(CourseExpiration data) => json.encode(data.toJson());

class CourseExpiration {
    int days;

    CourseExpiration({
        required this.days,
    });

    factory CourseExpiration.fromJson(Map<String, dynamic> json) => CourseExpiration(
        days: json["Days"],
    );

    Map<String, dynamic> toJson() => {
        "Days": days,
    };
}

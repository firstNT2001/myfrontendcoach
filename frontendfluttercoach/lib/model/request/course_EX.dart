// To parse this JSON data, do
//
//     final courseExpiration = courseExpirationFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CourseExpiration courseExpirationFromJson(String str) => CourseExpiration.fromJson(json.decode(str));

String courseExpirationToJson(CourseExpiration data) => json.encode(data.toJson());

class CourseExpiration {
    String status;

    CourseExpiration({
        required this.status,
    });

    factory CourseExpiration.fromJson(Map<String, dynamic> json) => CourseExpiration(
        status: json["Status"],
    );

    Map<String, dynamic> toJson() => {
        "Status": status,
    };
}

// To parse this JSON data, do
//
//     final courseCourseIdPut = courseCourseIdPutFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CourseCourseIdPut courseCourseIdPutFromJson(String str) => CourseCourseIdPut.fromJson(json.decode(str));

String courseCourseIdPutToJson(CourseCourseIdPut data) => json.encode(data.toJson());

class CourseCourseIdPut {
    String name;
    String details;
    String level;
    int amount;
    String image;
    int days;
    int price;
    String status;

    CourseCourseIdPut({
        required this.name,
        required this.details,
        required this.level,
        required this.amount,
        required this.image,
        required this.days,
        required this.price,
        required this.status,
    });

    factory CourseCourseIdPut.fromJson(Map<String, dynamic> json) => CourseCourseIdPut(
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

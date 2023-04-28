// To parse this JSON data, do
//
//     final insertCourseDto = insertCourseDtoFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

InsertCourseDto insertCourseDtoFromJson(String str) => InsertCourseDto.fromJson(json.decode(str));

String insertCourseDtoToJson(InsertCourseDto data) => json.encode(data.toJson());

class InsertCourseDto {
    InsertCourseDto({
        required this.cid,
        required this.bid,
        required this.name,
        required this.details,
        required this.level,
        required this.amount,
        required this.image,
        required this.days,
        required this.price,
        required this.status,
        required this.expirationDate,
    });

    int cid;
    dynamic bid;
    String name;
    String details;
    String level;
    int amount;
    String image;
    int days;
    int price;
    String status;
    dynamic expirationDate;

    factory InsertCourseDto.fromJson(Map<String, dynamic> json) => InsertCourseDto(
        cid: json["Cid"],
        bid: json["Bid"],
        name: json["Name"],
        details: json["Details"],
        level: json["Level"],
        amount: json["Amount"],
        image: json["Image"],
        days: json["Days"],
        price: json["Price"],
        status: json["Status"],
        expirationDate: json["ExpirationDate"],
    );

    Map<String, dynamic> toJson() => {
        "Cid": cid,
        "Bid": bid,
        "Name": name,
        "Details": details,
        "Level": level,
        "Amount": amount,
        "Image": image,
        "Days": days,
        "Price": price,
        "Status": status,
        "ExpirationDate": expirationDate,
    };
}
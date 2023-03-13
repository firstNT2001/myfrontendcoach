// To parse this JSON data, do
//
//     final modelCourse = modelCourseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ModelCourse modelCourseFromJson(String str) => ModelCourse.fromJson(json.decode(str));

String modelCourseToJson(ModelCourse data) => json.encode(data.toJson());

class ModelCourse {
    ModelCourse({
        required this.coId,
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

    int coId;
    int cid;
    int bid;
    String name;
    String details;
    String level;
    int amount;
    String image;
    int days;
    int price;
    String status;
    String expirationDate;

    factory ModelCourse.fromJson(Map<String, dynamic> json) => ModelCourse(
        coId: json["CoID"],
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
        "CoID": coId,
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

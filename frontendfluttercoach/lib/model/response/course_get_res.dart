// To parse this JSON data, do
//
//     final modelCourse = modelCourseFromJson(jsonString);

import 'package:frontendfluttercoach/model/response/md_Buying_get.dart';
import 'dart:convert';



List<ModelCourse> modelCourseFromJson(String str) => List<ModelCourse>.from(json.decode(str).map((x) => ModelCourse.fromJson(x)));

String modelCourseToJson(List<ModelCourse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelCourse {
    int coId;
    int coachId;
    int buyingId;
    String name;
    String details;
    String level;
    int amount;
    String image;
    int days;
    int price;
    String status;
    DateTime expirationDate;
    ModelBuying buying;
    dynamic dayOfCouses;

    ModelCourse({
        required this.coId,
        required this.coachId,
        required this.buyingId,
        required this.name,
        required this.details,
        required this.level,
        required this.amount,
        required this.image,
        required this.days,
        required this.price,
        required this.status,
        required this.expirationDate,
        required this.buying,
        required this.dayOfCouses,
    });

    factory ModelCourse.fromJson(Map<String, dynamic> json) => ModelCourse(
        coId: json["CoID"],
        coachId: json["CoachID"],
        buyingId: json["BuyingID"],
        name: json["Name"],
        details: json["Details"],
        level: json["Level"],
        amount: json["Amount"],
        image: json["Image"],
        days: json["Days"],
        price: json["Price"],
        status: json["Status"],
        expirationDate: DateTime.parse(json["ExpirationDate"]),
        buying: ModelBuying.fromJson(json["Buying"]),
        dayOfCouses: json["DayOfCouses"],
    );

    Map<String, dynamic> toJson() => {
        "CoID": coId,
        "CoachID": coachId,
        "BuyingID": buyingId,
        "Name": name,
        "Details": details,
        "Level": level,
        "Amount": amount,
        "Image": image,
        "Days": days,
        "Price": price,
        "Status": status,
        "ExpirationDate": expirationDate.toIso8601String(),
        "Buying": buying.toJson(),
        "DayOfCouses": dayOfCouses,
    };
}





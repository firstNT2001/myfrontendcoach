// To parse this JSON data, do
//
//     final coachbycourse = coachbycourseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'md_Buying_get.dart';
import 'md_Coach_get.dart';

List<Coachbycourse> coachbycourseFromJson(String str) => List<Coachbycourse>.from(json.decode(str).map((x) => Coachbycourse.fromJson(x)));

String coachbycourseToJson(List<Coachbycourse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Coachbycourse {
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
    String expirationDate;
    Coach coach;
    ModelBuying buying;
    dynamic dayOfCouses;

    Coachbycourse({
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
        required this.coach,
        required this.buying,
        required this.dayOfCouses,
    });

    factory Coachbycourse.fromJson(Map<String, dynamic> json) => Coachbycourse(
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
        expirationDate:json["ExpirationDate"],
        coach: Coach.fromJson(json["Coach"]),
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
        "ExpirationDate": expirationDate,
        "Coach": coach.toJson(),
        "Buying": buying.toJson(),
        "DayOfCouses": dayOfCouses,
    };
}






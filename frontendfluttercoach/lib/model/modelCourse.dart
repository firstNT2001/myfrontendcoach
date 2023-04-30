// To parse this JSON data, do
//
//     final modelCourse = modelCourseFromJson(jsonString);

import 'package:meta/meta.dart';
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
    String expirationDate;
    List<DayOfCouse> dayOfCouses;

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
        expirationDate: json["ExpirationDate"],
        dayOfCouses: List<DayOfCouse>.from(json["DayOfCouses"].map((x) => DayOfCouse.fromJson(x))),
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
        "DayOfCouses": List<dynamic>.from(dayOfCouses.map((x) => x.toJson())),
    };
}

class DayOfCouse {
    int did;
    int courseId;
    int sequence;
    dynamic foods;
    dynamic clips;

    DayOfCouse({
        required this.did,
        required this.courseId,
        required this.sequence,
        required this.foods,
        required this.clips,
    });

    factory DayOfCouse.fromJson(Map<String, dynamic> json) => DayOfCouse(
        did: json["Did"],
        courseId: json["CourseID"],
        sequence: json["Sequence"],
        foods: json["Foods"],
        clips: json["Clips"],
    );

    Map<String, dynamic> toJson() => {
        "Did": did,
        "CourseID": courseId,
        "Sequence": sequence,
        "Foods": foods,
        "Clips": clips,
    };
}

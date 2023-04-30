// To parse this JSON data, do
//
//     final listFoodPostRequest = listFoodPostRequestFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ListFoodPostRequest listFoodPostRequestFromJson(String str) => ListFoodPostRequest.fromJson(json.decode(str));

String listFoodPostRequestToJson(ListFoodPostRequest data) => json.encode(data.toJson());

class ListFoodPostRequest {
    int coachId;
    String name;
    String image;
    String details;
    int calories;

    ListFoodPostRequest({
        required this.coachId,
        required this.name,
        required this.image,
        required this.details,
        required this.calories,
    });

    factory ListFoodPostRequest.fromJson(Map<String, dynamic> json) => ListFoodPostRequest(
        coachId: json["CoachID"],
        name: json["Name"],
        image: json["Image"],
        details: json["Details"],
        calories: json["Calories"],
    );

    Map<String, dynamic> toJson() => {
        "CoachID": coachId,
        "Name": name,
        "Image": image,
        "Details": details,
        "Calories": calories,
    };
}

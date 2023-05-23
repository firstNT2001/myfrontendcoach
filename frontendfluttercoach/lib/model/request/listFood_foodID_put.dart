// To parse this JSON data, do
//
//     final listFoodFoodIdPut = listFoodFoodIdPutFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ListFoodFoodIdPut listFoodFoodIdPutFromJson(String str) => ListFoodFoodIdPut.fromJson(json.decode(str));

String listFoodFoodIdPutToJson(ListFoodFoodIdPut data) => json.encode(data.toJson());

class ListFoodFoodIdPut {
    String name;
    String image;
    String details;
    int calories;
    int coachId;

    ListFoodFoodIdPut({
        required this.name,
        required this.image,
        required this.details,
        required this.calories,
        required this.coachId,
    });

    factory ListFoodFoodIdPut.fromJson(Map<String, dynamic> json) => ListFoodFoodIdPut(
        name: json["Name"],
        image: json["Image"],
        details: json["Details"],
        calories: json["Calories"],
        coachId: json["CoachID"],
    );

    Map<String, dynamic> toJson() => {
        "Name": name,
        "Image": image,
        "Details": details,
        "Calories": calories,
        "CoachID": coachId,
    };
}

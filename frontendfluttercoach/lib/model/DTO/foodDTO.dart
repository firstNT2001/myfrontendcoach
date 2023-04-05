// To parse this JSON data, do
//
//     final foodDto = foodDtoFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

FoodDto foodDtoFromJson(String str) => FoodDto.fromJson(json.decode(str));

String foodDtoToJson(FoodDto data) => json.encode(data.toJson());

class FoodDto {
    FoodDto({
        required this.cid,
        required this.name,
        required this.image,
        required this.details,
        required this.calories,
    });

    int cid;
    String name;
    String image;
    String details;
    int calories;

    factory FoodDto.fromJson(Map<String, dynamic> json) => FoodDto(
        cid: json["Cid"],
        name: json["Name"],
        image: json["Image"],
        details: json["Details"],
        calories: json["Calories"],
    );

    Map<String, dynamic> toJson() => {
        "Cid": cid,
        "Name": name,
        "Image": image,
        "Details": details,
        "Calories": calories,
    };
}

// To parse this JSON data, do
//
//     final listFoodDto = listFoodDtoFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ListFoodDto listFoodDtoFromJson(String str) => ListFoodDto.fromJson(json.decode(str));

String listFoodDtoToJson(ListFoodDto data) => json.encode(data.toJson());

class ListFoodDto {
    ListFoodDto({
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

    factory ListFoodDto.fromJson(Map<String, dynamic> json) => ListFoodDto(
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

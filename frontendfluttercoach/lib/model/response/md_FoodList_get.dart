// To parse this JSON data, do
//
//     final modelFoodList = modelFoodListFromJson(jsonString);

import 'dart:convert';

ModelFoodList modelFoodListFromJson(String str) => ModelFoodList.fromJson(json.decode(str));

String modelFoodListToJson(ModelFoodList data) => json.encode(data.toJson());

class ModelFoodList {
    int ifid;
    String name;
    String image;
    String details;
    int calories;

    ModelFoodList({
        required this.ifid,
        required this.name,
        required this.image,
        required this.details,
        required this.calories,
    });

    factory ModelFoodList.fromJson(Map<String, dynamic> json) => ModelFoodList(
        ifid: json["Ifid"],
        name: json["Name"],
        image: json["Image"],
        details: json["Details"],
        calories: json["Calories"],
    );

    Map<String, dynamic> toJson() => {
        "Ifid": ifid,
        "Name": name,
        "Image": image,
        "Details": details,
        "Calories": calories,
    };
}

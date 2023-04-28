// To parse this JSON data, do
//
//     final modelListFood = modelListFoodFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<ModelListFood> modelListFoodFromJson(String str) => List<ModelListFood>.from(json.decode(str).map((x) => ModelListFood.fromJson(x)));

String modelListFoodToJson(List<ModelListFood> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelListFood {
    ModelListFood({
        required this.ifid,
        required this.cid,
        required this.name,
        required this.image,
        required this.details,
        required this.calories,
    });

    int ifid;
    int cid;
    String name;
    String image;
    String details;
    int calories;

    factory ModelListFood.fromJson(Map<String, dynamic> json) => ModelListFood(
        ifid: json["Ifid"],
        cid: json["Cid"],
        name: json["Name"],
        image: json["Image"],
        details: json["Details"],
        calories: json["Calories"],
    );

    Map<String, dynamic> toJson() => {
        "Ifid": ifid,
        "Cid": cid,
        "Name": name,
        "Image": image,
        "Details": details,
        "Calories": calories,
    };
}

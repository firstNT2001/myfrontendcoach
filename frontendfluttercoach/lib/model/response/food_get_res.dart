// To parse this JSON data, do
//
//     final modelFood = modelFoodFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'md_FoodList_get.dart';

List<ModelFood> modelFoodFromJson(String str) => List<ModelFood>.from(json.decode(str).map((x) => ModelFood.fromJson(x)));

String modelFoodToJson(List<ModelFood> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelFood {
    int fid;
    int listFoodId;
    int dayOfCouseId;
    String time;
    ModelFoodList listFood;

    ModelFood({
        required this.fid,
        required this.listFoodId,
        required this.dayOfCouseId,
        required this.time,
        required this.listFood,
    });

    factory ModelFood.fromJson(Map<String, dynamic> json) => ModelFood(
        fid: json["Fid"],
        listFoodId: json["ListFoodID"],
        dayOfCouseId: json["DayOfCouseID"],
        time: json["Time"],
        listFood: ModelFoodList.fromJson(json["ListFood"]),
    );

    Map<String, dynamic> toJson() => {
        "Fid": fid,
        "ListFoodID": listFoodId,
        "DayOfCouseID": dayOfCouseId,
        "Time": time,
        "ListFood": listFood.toJson(),
    };
}


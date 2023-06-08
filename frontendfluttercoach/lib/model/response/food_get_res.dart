// To parse this JSON data, do
//
//     final modelFood = modelFoodFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<ModelFood> modelFoodFromJson(String str) => List<ModelFood>.from(json.decode(str).map((x) => ModelFood.fromJson(x)));

String modelFoodToJson(List<ModelFood> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelFood {
    int fid;
    int listFoodId;
    int dayOfCouseId;
    String time;
    ListFood listFood;

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
        listFood: ListFood.fromJson(json["ListFood"]),
    );

    Map<String, dynamic> toJson() => {
        "Fid": fid,
        "ListFoodID": listFoodId,
        "DayOfCouseID": dayOfCouseId,
        "Time": time,
        "ListFood": listFood.toJson(),
    };
}

class ListFood {
    int ifid;
    int coachId;
    String name;
    String image;
    String details;
    int calories;

    ListFood({
        required this.ifid,
        required this.coachId,
        required this.name,
        required this.image,
        required this.details,
        required this.calories,
    });

    factory ListFood.fromJson(Map<String, dynamic> json) => ListFood(
        ifid: json["Ifid"],
        coachId: json["CoachID"],
        name: json["Name"],
        image: json["Image"],
        details: json["Details"],
        calories: json["Calories"],
    );

    Map<String, dynamic> toJson() => {
        "Ifid": ifid,
        "CoachID": coachId,
        "Name": name,
        "Image": image,
        "Details": details,
        "Calories": calories,
    };
}

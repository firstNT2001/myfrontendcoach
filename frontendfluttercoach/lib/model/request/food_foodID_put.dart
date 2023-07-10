// To parse this JSON data, do
//
//     final foodFoodIdPut = foodFoodIdPutFromJson(jsonString);

import 'dart:convert';

FoodFoodIdPut foodFoodIdPutFromJson(String str) => FoodFoodIdPut.fromJson(json.decode(str));

String foodFoodIdPutToJson(FoodFoodIdPut data) => json.encode(data.toJson());

class FoodFoodIdPut {
    int dayOfCouseId;
    int listFoodId;
    String time;

    FoodFoodIdPut({
        required this.dayOfCouseId,
        required this.listFoodId,
        required this.time,
    });

    factory FoodFoodIdPut.fromJson(Map<String, dynamic> json) => FoodFoodIdPut(
        dayOfCouseId: json["DayOfCouseID"],
        listFoodId: json["ListFoodID"],
        time: json["time"],
    );

    Map<String, dynamic> toJson() => {
        "DayOfCouseID": dayOfCouseId,
        "ListFoodID": listFoodId,
        "time": time,
    };
}

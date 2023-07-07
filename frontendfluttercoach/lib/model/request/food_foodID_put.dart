// To parse this JSON data, do
//
//     final foodFoodIdPut = foodFoodIdPutFromJson(jsonString);

import 'dart:convert';

FoodFoodIdPut foodFoodIdPutFromJson(String str) => FoodFoodIdPut.fromJson(json.decode(str));

String foodFoodIdPutToJson(FoodFoodIdPut data) => json.encode(data.toJson());

class FoodFoodIdPut {
    int listFoodId;
    String time;

    FoodFoodIdPut({
        required this.listFoodId,
        required this.time,
    });

    factory FoodFoodIdPut.fromJson(Map<String, dynamic> json) => FoodFoodIdPut(
        listFoodId: json["ListFoodID"],
        time: json["time"],
    );

    Map<String, dynamic> toJson() => {
        "ListFoodID": listFoodId,
        "time": time,
    };
}

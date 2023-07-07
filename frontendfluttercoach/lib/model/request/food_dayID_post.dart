// To parse this JSON data, do
//
//     final foodDayIdPost = foodDayIdPostFromJson(jsonString);

import 'dart:convert';

FoodDayIdPost foodDayIdPostFromJson(String str) => FoodDayIdPost.fromJson(json.decode(str));

String foodDayIdPostToJson(FoodDayIdPost data) => json.encode(data.toJson());

class FoodDayIdPost {
    int listFoodId;
    String time;

    FoodDayIdPost({
        required this.listFoodId,
        required this.time,
    });

    factory FoodDayIdPost.fromJson(Map<String, dynamic> json) => FoodDayIdPost(
        listFoodId: json["ListFoodID"],
        time: json["time"],
    );

    Map<String, dynamic> toJson() => {
        "ListFoodID": listFoodId,
        "time": time,
    };
}

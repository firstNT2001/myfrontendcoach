// To parse this JSON data, do
//
//     final listFoodCoachIdPost = listFoodCoachIdPostFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ListFoodCoachIdPost listFoodCoachIdPostFromJson(String str) => ListFoodCoachIdPost.fromJson(json.decode(str));

String listFoodCoachIdPostToJson(ListFoodCoachIdPost data) => json.encode(data.toJson());

class ListFoodCoachIdPost {
    String name;
    String image;
    String details;
    int calories;

    ListFoodCoachIdPost({
        required this.name,
        required this.image,
        required this.details,
        required this.calories,
    });

    factory ListFoodCoachIdPost.fromJson(Map<String, dynamic> json) => ListFoodCoachIdPost(
        name: json["Name"],
        image: json["Image"],
        details: json["Details"],
        calories: json["Calories"],
    );

    Map<String, dynamic> toJson() => {
        "Name": name,
        "Image": image,
        "Details": details,
        "Calories": calories,
    };
}

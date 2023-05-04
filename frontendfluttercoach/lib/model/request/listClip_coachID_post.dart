// To parse this JSON data, do
//
//     final listClipCoachIdPost = listClipCoachIdPostFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ListClipCoachIdPost listClipCoachIdPostFromJson(String str) => ListClipCoachIdPost.fromJson(json.decode(str));

String listClipCoachIdPostToJson(ListClipCoachIdPost data) => json.encode(data.toJson());

class ListClipCoachIdPost {
    String name;
    String image;
    String details;
    int calories;

    ListClipCoachIdPost({
        required this.name,
        required this.image,
        required this.details,
        required this.calories,
    });

    factory ListClipCoachIdPost.fromJson(Map<String, dynamic> json) => ListClipCoachIdPost(
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

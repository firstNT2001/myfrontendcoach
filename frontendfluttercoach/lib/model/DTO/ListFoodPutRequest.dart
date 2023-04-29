// To parse this JSON data, do
//
//     final listFoodPutRequest = listFoodPutRequestFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ListFoodPutRequest listFoodPutRequestFromJson(String str) => ListFoodPutRequest.fromJson(json.decode(str));

String listFoodPutRequestToJson(ListFoodPutRequest data) => json.encode(data.toJson());

class ListFoodPutRequest {
    int ifid;
    String name;
    String image;
    String details;
    int calories;

    ListFoodPutRequest({
        required this.ifid,
        required this.name,
        required this.image,
        required this.details,
        required this.calories,
    });

    factory ListFoodPutRequest.fromJson(Map<String, dynamic> json) => ListFoodPutRequest(
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

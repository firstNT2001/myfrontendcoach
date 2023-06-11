// To parse this JSON data, do
//
//     final dayDetail = dayDetailFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'food_get_res.dart';
import 'md_FoodList_get.dart';

List<DayDetail> dayDetailFromJson(String str) => List<DayDetail>.from(json.decode(str).map((x) => DayDetail.fromJson(x)));

String dayDetailToJson(List<DayDetail> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DayDetail {
    int did;
    int courseId;
    int sequence;
    List<ModelFood> foods;
    List<dynamic> clips;

    DayDetail({
        required this.did,
        required this.courseId,
        required this.sequence,
        required this.foods,
        required this.clips,
    });

    factory DayDetail.fromJson(Map<String, dynamic> json) => DayDetail(
        did: json["Did"],
        courseId: json["CourseID"],
        sequence: json["Sequence"],
        foods: List<ModelFood>.from(json["Foods"].map((x) => ModelFood.fromJson(x))),
        clips: List<dynamic>.from(json["Clips"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "Did": did,
        "CourseID": courseId,
        "Sequence": sequence,
        "Foods": List<dynamic>.from(foods.map((x) => x.toJson())),
        "Clips": List<dynamic>.from(clips.map((x) => x)),
    };
}




// To parse this JSON data, do
//
//     final modelDay = modelDayFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<ModelDay> modelDayFromJson(String str) => List<ModelDay>.from(json.decode(str).map((x) => ModelDay.fromJson(x)));

String modelDayToJson(List<ModelDay> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelDay {
    int did;
    int courseId;
    int sequence;
    List<Food> foods;
    List<dynamic> clips;

    ModelDay({
        required this.did,
        required this.courseId,
        required this.sequence,
        required this.foods,
        required this.clips,
    });

    factory ModelDay.fromJson(Map<String, dynamic> json) => ModelDay(
        did: json["Did"],
        courseId: json["CourseID"],
        sequence: json["Sequence"],
        foods: List<Food>.from(json["Foods"].map((x) => Food.fromJson(x))),
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

class Food {
    int fid;
    int listFoodId;
    int dayOfCouseId;
    String time;
    ListFood listFood;

    Food({
        required this.fid,
        required this.listFoodId,
        required this.dayOfCouseId,
        required this.time,
        required this.listFood,
    });

    factory Food.fromJson(Map<String, dynamic> json) => Food(
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

// To parse this JSON data, do
//
//     final listClipCoachIdPost = listClipCoachIdPostFromJson(jsonString);

import 'dart:convert';

ListClipCoachIdPost listClipCoachIdPostFromJson(String str) => ListClipCoachIdPost.fromJson(json.decode(str));

String listClipCoachIdPostToJson(ListClipCoachIdPost data) => json.encode(data.toJson());

class ListClipCoachIdPost {
    String name;
    String amountPerSet;
    String video;
    String details;

    ListClipCoachIdPost({
        required this.name,
        required this.amountPerSet,
        required this.video,
        required this.details,
    });

    factory ListClipCoachIdPost.fromJson(Map<String, dynamic> json) => ListClipCoachIdPost(
        name: json["Name"],
        amountPerSet: json["AmountPerSet"],
        video: json["Video"],
        details: json["Details"],
    );

    Map<String, dynamic> toJson() => {
        "Name": name,
        "AmountPerSet": amountPerSet,
        "Video": video,
        "Details": details,
    };
}

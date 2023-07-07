// To parse this JSON data, do
//
//     final modelClipList = modelClipListFromJson(jsonString);

import 'dart:convert';

List<ModelClipList> modelClipListFromJson(String str) => List<ModelClipList>.from(json.decode(str).map((x) => ModelClipList.fromJson(x)));

String modelClipListToJson(List<ModelClipList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelClipList {
    int icpId;
    int coachId;
    String name;
    String amountPerSet;
    String video;
    String details;

    ModelClipList({
        required this.icpId,
        required this.coachId,
        required this.name,
        required this.amountPerSet,
        required this.video,
        required this.details,
    });

    factory ModelClipList.fromJson(Map<String, dynamic> json) => ModelClipList(
        icpId: json["IcpID"],
        coachId: json["CoachID"],
        name: json["Name"],
        amountPerSet: json["AmountPerSet"],
        video: json["Video"],
        details: json["Details"],
    );

    Map<String, dynamic> toJson() => {
        "IcpID": icpId,
        "CoachID": coachId,
        "Name": name,
        "AmountPerSet": amountPerSet,
        "Video": video,
        "Details": details,
    };
}

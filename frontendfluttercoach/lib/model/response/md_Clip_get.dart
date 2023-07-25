// To parse this JSON data, do
//
//     final clip = clipFromJson(jsonString);

import 'dart:convert';

import 'md_ClipList_get.dart';

List<Clip> clipFromJson(String str) => List<Clip>.from(json.decode(str).map((x) => Clip.fromJson(x)));

String clipToJson(List<Clip> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Clip {
    int cpId;
    int listClipId;
    int dayOfCouseId;
    String status;
    ListClip listClip;

    Clip({
        required this.cpId,
        required this.listClipId,
        required this.dayOfCouseId,
        required this.status,
        required this.listClip,
    });

    factory Clip.fromJson(Map<String, dynamic> json) => Clip(
        cpId: json["CpID"],
        listClipId: json["ListClipID"],
        dayOfCouseId: json["DayOfCouseID"],
        status: json["Status"],
        listClip: ListClip.fromJson(json["ListClip"]),
    );

    Map<String, dynamic> toJson() => {
        "CpID": cpId,
        "ListClipID": listClipId,
        "DayOfCouseID": dayOfCouseId,
        "Status": status,
        "ListClip": listClip.toJson(),
    };
}
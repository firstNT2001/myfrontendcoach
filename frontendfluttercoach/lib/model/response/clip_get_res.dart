// To parse this JSON data, do
//
//     final modelClip = modelClipFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'md_ClipList_get.dart';

List<ModelClip> modelClipFromJson(String str) => List<ModelClip>.from(json.decode(str).map((x) => ModelClip.fromJson(x)));

String modelClipToJson(List<ModelClip> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelClip {
    int cpId;
    int listClipId;
    int dayOfCouseId;
    int status;
    ModelClipList listClip;

    ModelClip({
        required this.cpId,
        required this.listClipId,
        required this.dayOfCouseId,
        required this.status,
        required this.listClip,
    });

    factory ModelClip.fromJson(Map<String, dynamic> json) => ModelClip(
        cpId: json["CpID"],
        listClipId: json["ListClipID"],
        dayOfCouseId: json["DayOfCouseID"],
        status: json["Status"],
        listClip: ModelClipList.fromJson(json["ListClip"]),
    );

    Map<String, dynamic> toJson() => {
        "CpID": cpId,
        "ListClipID": listClipId,
        "DayOfCouseID": dayOfCouseId,
        "Status": status,
        "ListClip": listClip.toJson(),
    };
}



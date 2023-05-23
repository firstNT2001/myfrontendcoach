// To parse this JSON data, do
//
//     final listClipClipIdPut = listClipClipIdPutFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ListClipClipIdPut listClipClipIdPutFromJson(String str) => ListClipClipIdPut.fromJson(json.decode(str));

String listClipClipIdPutToJson(ListClipClipIdPut data) => json.encode(data.toJson());

class ListClipClipIdPut {
    String name;
    String amountPerSet;
    String video;
    String details;
    int coachId;

    ListClipClipIdPut({
        required this.name,
        required this.amountPerSet,
        required this.video,
        required this.details,
        required this.coachId,
    });

    factory ListClipClipIdPut.fromJson(Map<String, dynamic> json) => ListClipClipIdPut(
        name: json["Name"],
        amountPerSet: json["AmountPerSet"],
        video: json["Video"],
        details: json["Details"],
        coachId: json["CoachID"],
    );

    Map<String, dynamic> toJson() => {
        "Name": name,
        "AmountPerSet": amountPerSet,
        "Video": video,
        "Details": details,
        "CoachID": coachId,
    };
}

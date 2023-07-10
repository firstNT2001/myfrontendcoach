// To parse this JSON data, do
//
//     final clipClipIdPut = clipClipIdPutFromJson(jsonString);

import 'dart:convert';

ClipClipIdPut clipClipIdPutFromJson(String str) => ClipClipIdPut.fromJson(json.decode(str));

String clipClipIdPutToJson(ClipClipIdPut data) => json.encode(data.toJson());

class ClipClipIdPut {
    int dayOfCouseId;
    int listClipId;

    ClipClipIdPut({
        required this.dayOfCouseId,
        required this.listClipId,
    });

    factory ClipClipIdPut.fromJson(Map<String, dynamic> json) => ClipClipIdPut(
        dayOfCouseId: json["DayOfCouseID"],
        listClipId: json["ListClipID"],
    );

    Map<String, dynamic> toJson() => {
        "DayOfCouseID": dayOfCouseId,
        "ListClipID": listClipId,
    };
}

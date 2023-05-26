// To parse this JSON data, do
//
//     final clipClipIdPut = clipClipIdPutFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ClipClipIdPut clipClipIdPutFromJson(String str) => ClipClipIdPut.fromJson(json.decode(str));

String clipClipIdPutToJson(ClipClipIdPut data) => json.encode(data.toJson());

class ClipClipIdPut {
    int listClipId;
    int status;

    ClipClipIdPut({
        required this.listClipId,
        required this.status,
    });

    factory ClipClipIdPut.fromJson(Map<String, dynamic> json) => ClipClipIdPut(
        listClipId: json["ListClipID"],
        status: json["Status"],
    );

    Map<String, dynamic> toJson() => {
        "ListClipID": listClipId,
        "Status": status,
    };
}

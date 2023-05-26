// To parse this JSON data, do
//
//     final clipDayIdPost = clipDayIdPostFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ClipDayIdPost clipDayIdPostFromJson(String str) => ClipDayIdPost.fromJson(json.decode(str));

String clipDayIdPostToJson(ClipDayIdPost data) => json.encode(data.toJson());

class ClipDayIdPost {
    int listClipId;
    int status;

    ClipDayIdPost({
        required this.listClipId,
        required this.status,
    });

    factory ClipDayIdPost.fromJson(Map<String, dynamic> json) => ClipDayIdPost(
        listClipId: json["ListClipID"],
        status: json["Status"],
    );

    Map<String, dynamic> toJson() => {
        "ListClipID": listClipId,
        "Status": status,
    };
}

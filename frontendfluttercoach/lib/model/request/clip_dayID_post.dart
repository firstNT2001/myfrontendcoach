// To parse this JSON data, do
//
//     final clipDayIdPost = clipDayIdPostFromJson(jsonString);

import 'dart:convert';

ClipDayIdPost clipDayIdPostFromJson(String str) => ClipDayIdPost.fromJson(json.decode(str));

String clipDayIdPostToJson(ClipDayIdPost data) => json.encode(data.toJson());

class ClipDayIdPost {
    int listClipId;

    ClipDayIdPost({
        required this.listClipId,
    });

    factory ClipDayIdPost.fromJson(Map<String, dynamic> json) => ClipDayIdPost(
        listClipId: json["ListClipID"],
    );

    Map<String, dynamic> toJson() => {
        "ListClipID": listClipId,
    };
}

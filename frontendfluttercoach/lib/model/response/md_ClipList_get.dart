// To parse this JSON data, do
//
//     final listClip = listClipFromJson(jsonString);

import 'dart:convert';

List<ListClip> listClipFromJson(String str) => List<ListClip>.from(json.decode(str).map((x) => ListClip.fromJson(x)));

String listClipToJson(List<ListClip> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListClip {
    int icpId;
    int coachId;
    String name;
    String amountPerSet;
    String video;
    String details;

    ListClip({
        required this.icpId,
        required this.coachId,
        required this.name,
        required this.amountPerSet,
        required this.video,
        required this.details,
    });

    factory ListClip.fromJson(Map<String, dynamic> json) => ListClip(
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

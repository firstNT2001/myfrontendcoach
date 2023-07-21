// To parse this JSON data, do
//
//     final modelClip = modelClipFromJson(jsonString);

import 'dart:convert';

List<Clip> modelClipFromJson(String str) => List<Clip>.from(json.decode(str).map((x) => Clip.fromJson(x)));

String modelClipToJson(List<Clip> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Clip {
    int cpId;
    int listClipId;
    int dayOfCouseId;
    int status;
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

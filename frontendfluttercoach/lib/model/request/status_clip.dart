// To parse this JSON data, do
//
//     final statusClip = statusClipFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

StatusClip statusClipFromJson(String str) => StatusClip.fromJson(json.decode(str));

String statusClipToJson(StatusClip data) => json.encode(data.toJson());

class StatusClip {
    String status;

    StatusClip({
        required this.status,
    });

    factory StatusClip.fromJson(Map<String, dynamic> json) => StatusClip(
        status: json["Status"],
    );

    Map<String, dynamic> toJson() => {
        "Status": status,
    };
}

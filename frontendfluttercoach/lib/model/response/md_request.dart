// To parse this JSON data, do
//
//     final modelRequest = modelRequestFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<ModelRequest> modelRequestFromJson(String str) => List<ModelRequest>.from(json.decode(str).map((x) => ModelRequest.fromJson(x)));

String modelRequestToJson(List<ModelRequest> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelRequest {
    int rpId;
    int coachId;
    int customerId;
    int clipId;
    String status;
    String details;

    ModelRequest({
        required this.rpId,
        required this.coachId,
        required this.customerId,
        required this.clipId,
        required this.status,
        required this.details,
    });

    factory ModelRequest.fromJson(Map<String, dynamic> json) => ModelRequest(
        rpId: json["RpID"],
        coachId: json["CoachID"],
        customerId: json["CustomerID"],
        clipId: json["ClipID"],
        status: json["Status"],
        details: json["Details"],
    );

    Map<String, dynamic> toJson() => {
        "RpID": rpId,
        "CoachID": coachId,
        "CustomerID": customerId,
        "ClipID": clipId,
        "Status": status,
        "Details": details,
    };
}

// To parse this JSON data, do
//
//     final modelRequest = modelRequestFromJson(jsonString);

import 'dart:convert';

import 'md_Clip_get.dart';
import 'md_Customer_get.dart';

List<ModelRequest> modelRequestFromJson(String str) => List<ModelRequest>.from(json.decode(str).map((x) => ModelRequest.fromJson(x)));

String modelRequestToJson(List<ModelRequest> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelRequest {
    int rpId;
    int coachId;
    int customerId;
    int clipId;
    String status;
    String details;
    Customer customer;
    ModelClip clip;

    ModelRequest({
        required this.rpId,
        required this.coachId,
        required this.customerId,
        required this.clipId,
        required this.status,
        required this.details,
        required this.customer,
        required this.clip,
    });

    factory ModelRequest.fromJson(Map<String, dynamic> json) => ModelRequest(
        rpId: json["RpID"],
        coachId: json["CoachID"],
        customerId: json["CustomerID"],
        clipId: json["ClipID"],
        status: json["Status"],
        details: json["Details"],
        customer: Customer.fromJson(json["Customer"]),
        clip: ModelClip.fromJson(json["Clip"]),
    );

    Map<String, dynamic> toJson() => {
        "RpID": rpId,
        "CoachID": coachId,
        "CustomerID": customerId,
        "ClipID": clipId,
        "Status": status,
        "Details": details,
        "Customer": customer.toJson(),
        "Clip": clip.toJson(),
    };
}
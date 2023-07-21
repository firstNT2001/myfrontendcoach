// To parse this JSON data, do
//
//     final request = requestFromJson(jsonString);

import 'dart:convert';

import 'md_Clip_get.dart';
import 'md_Customer_get.dart';

List<Request> requestFromJson(String str) => List<Request>.from(json.decode(str).map((x) => Request.fromJson(x)));

String requestToJson(List<Request> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Request {
    int rpId;
    int coachId;
    int customerId;
    int clipId;
    String status;
    String details;
    Customer customer;
    Clip clip;

    Request({
        required this.rpId,
        required this.coachId,
        required this.customerId,
        required this.clipId,
        required this.status,
        required this.details,
        required this.customer,
        required this.clip,
    });

    factory Request.fromJson(Map<String, dynamic> json) => Request(
        rpId: json["RpID"],
        coachId: json["CoachID"],
        customerId: json["CustomerID"],
        clipId: json["ClipID"],
        status: json["Status"],
        details: json["Details"],
        customer: Customer.fromJson(json["Customer"]),
        clip: Clip.fromJson(json["Clip"]),
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


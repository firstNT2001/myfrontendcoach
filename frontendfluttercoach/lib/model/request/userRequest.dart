// To parse this JSON data, do
//
//     final userRequest = userRequestFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UserRequest userRequestFromJson(String str) => UserRequest.fromJson(json.decode(str));

String userRequestToJson(UserRequest data) => json.encode(data.toJson());

class UserRequest {
    int coachId;
    int clipId;
    String details;

    UserRequest({
        required this.coachId,
        required this.clipId,
        required this.details,
    });

    factory UserRequest.fromJson(Map<String, dynamic> json) => UserRequest(
        coachId: json["CoachID"],
        clipId: json["ClipID"],
        details: json["Details"],
    );

    Map<String, dynamic> toJson() => {
        "CoachID": coachId,
        "ClipID": clipId,
        "Details": details,
    };
}

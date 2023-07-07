// To parse this JSON data, do
//
//     final authLoginRes = authLoginResFromJson(jsonString);

import 'dart:convert';

AuthLoginRes authLoginResFromJson(String str) => AuthLoginRes.fromJson(json.decode(str));

String authLoginResToJson(AuthLoginRes data) => json.encode(data.toJson());

class AuthLoginRes {
    dynamic cid;
    int uid;

    AuthLoginRes({
        required this.cid,
        required this.uid,
    });

    factory AuthLoginRes.fromJson(Map<String, dynamic> json) => AuthLoginRes(
        cid: json["cid"],
        uid: json["uid"],
    );

    Map<String, dynamic> toJson() => {
        "cid": cid,
        "uid": uid,
    };
}

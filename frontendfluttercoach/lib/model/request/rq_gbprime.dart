// To parse this JSON data, do
//
//     final rqGbprime = rqGbprimeFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

RqGbprime rqGbprimeFromJson(String str) => RqGbprime.fromJson(json.decode(str));

String rqGbprimeToJson(RqGbprime data) => json.encode(data.toJson());

class RqGbprime {
    String token;
    String referenceNo;
    String backgroundUrl;
    double amount;

    RqGbprime({
        required this.token,
        required this.referenceNo,
        required this.backgroundUrl,
        required this.amount,
    });

    factory RqGbprime.fromJson(Map<String, dynamic> json) => RqGbprime(
        token: json["token"],
        referenceNo: json["referenceNo"],
        backgroundUrl: json["backgroundUrl"],
        amount: json["amount"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "referenceNo": referenceNo,
        "backgroundUrl": backgroundUrl,
        "amount": amount,
    };
}

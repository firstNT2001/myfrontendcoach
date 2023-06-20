// To parse this JSON data, do
//
//     final restGbprime = restGbprimeFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

RestGbprime restGbprimeFromJson(String str) => RestGbprime.fromJson(json.decode(str));

String restGbprimeToJson(RestGbprime data) => json.encode(data.toJson());

class RestGbprime {
    String contentType;

    RestGbprime({
        required this.contentType,
    });

    factory RestGbprime.fromJson(Map<String, dynamic> json) => RestGbprime(
        contentType: json["content-type"],
    );

    Map<String, dynamic> toJson() => {
        "content-type": contentType,
    };
}

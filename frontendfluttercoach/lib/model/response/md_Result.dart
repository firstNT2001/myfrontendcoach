// To parse this JSON data, do
//
//     final modelResult = modelResultFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ModelResult modelResultFromJson(String str) => ModelResult.fromJson(json.decode(str));

String modelResultToJson(ModelResult data) => json.encode(data.toJson());

class ModelResult {
    String code;
    String result;

    ModelResult({
        required this.code,
        required this.result,
    });

    factory ModelResult.fromJson(Map<String, dynamic> json) => ModelResult(
        code: json["code"],
        result: json["result"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "result": result,
    };
}

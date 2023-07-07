// To parse this JSON data, do
//
//     final modelRowsAffected = modelRowsAffectedFromJson(jsonString);

import 'dart:convert';

ModelRowsAffected modelRowsAffectedFromJson(String str) => ModelRowsAffected.fromJson(json.decode(str));

String modelRowsAffectedToJson(ModelRowsAffected data) => json.encode(data.toJson());

class ModelRowsAffected {
    ModelRowsAffected({
        required this.rowsAffected,
    });

    String rowsAffected;

    factory ModelRowsAffected.fromJson(Map<String, dynamic> json) => ModelRowsAffected(
        rowsAffected: json["rowsAffected"],
    );

    Map<String, dynamic> toJson() => {
        "rowsAffected": rowsAffected,
    };
}

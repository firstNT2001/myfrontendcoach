// To parse this JSON data, do
//
//     final modelprogessbar = modelprogessbarFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

Modelprogessbar modelprogessbarFromJson(String str) => Modelprogessbar.fromJson(json.decode(str));

String modelprogessbarToJson(Modelprogessbar data) => json.encode(data.toJson());

class Modelprogessbar {
    double percent;

    Modelprogessbar({
        required this.percent,
    });

    factory Modelprogessbar.fromJson(Map<String, dynamic> json) {
      debugPrint(json.toString());
      return Modelprogessbar(
        percent: json["percent"]?.toDouble(),
    );
    }

    Map<String, dynamic> toJson() => {
        "percent": percent,
    };
}

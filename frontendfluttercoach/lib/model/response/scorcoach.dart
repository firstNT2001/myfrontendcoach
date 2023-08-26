// To parse this JSON data, do
//
//     final scorecoach = scorecoachFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Scorecoach scorecoachFromJson(String str) => Scorecoach.fromJson(json.decode(str));

String scorecoachToJson(Scorecoach data) => json.encode(data.toJson());

class Scorecoach {
    int score;

    Scorecoach({
        required this.score,
    });

    factory Scorecoach.fromJson(Map<String, dynamic> json) => Scorecoach(
        score: json["score"],
    );

    Map<String, dynamic> toJson() => {
        "score": score,
    };
}

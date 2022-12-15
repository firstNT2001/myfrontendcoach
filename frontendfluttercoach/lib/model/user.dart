// To parse this JSON data, do
//
//     final destination = destinationFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Destination> destinationFromJson(String str) => List<Destination>.from(json.decode(str).map((x) => Destination.fromJson(x)));

String destinationToJson(List<Destination> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Destination {
    Destination({
        required this.email,
        required this.password,
    });

    String email;
    String password;

    factory Destination.fromJson(Map<String, dynamic> json) => Destination(
        email: json["email"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
    };
}

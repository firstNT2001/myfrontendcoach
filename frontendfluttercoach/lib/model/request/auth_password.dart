// To parse this JSON data, do
//
//     final authPassword = authPasswordFromJson(jsonString);

import 'dart:convert';

AuthPassword authPasswordFromJson(String str) => AuthPassword.fromJson(json.decode(str));

String authPasswordToJson(AuthPassword data) => json.encode(data.toJson());

class AuthPassword {
    String password;

    AuthPassword({
        required this.password,
    });

    factory AuthPassword.fromJson(Map<String, dynamic> json) => AuthPassword(
        password: json["Password"],
    );

    Map<String, dynamic> toJson() => {
        "Password": password,
    };
}

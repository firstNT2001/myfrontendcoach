// To parse this JSON data, do
//
//     final authLoginPost = authLoginPostFromJson(jsonString);

import 'dart:convert';

AuthLoginPost authLoginPostFromJson(String str) => AuthLoginPost.fromJson(json.decode(str));

String authLoginPostToJson(AuthLoginPost data) => json.encode(data.toJson());

class AuthLoginPost {
    String email;
    String password;

    AuthLoginPost({
        required this.email,
        required this.password,
    });

    factory AuthLoginPost.fromJson(Map<String, dynamic> json) => AuthLoginPost(
        email: json["Email"],
        password: json["Password"],
    );

    Map<String, dynamic> toJson() => {
        "Email": email,
        "Password": password,
    };
}

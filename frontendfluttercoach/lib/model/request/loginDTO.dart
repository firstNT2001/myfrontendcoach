// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'dart:convert';

LoginDto loginDtoFromJson(String str) => LoginDto.fromJson(json.decode(str));

String loginDtoToJson(LoginDto data) => json.encode(data.toJson());

class LoginDto {
    LoginDto({
        required this.email,
        required this.password,
        required this.type,
    });

    String email;
    String password;
    int type;

    factory LoginDto.fromJson(Map<String, dynamic> json) => LoginDto(
        email: json["email"],
        password: json["password"],
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "type": type,
    };
}
// To parse this JSON data, do
//
//     final loginFbDto = loginFbDtoFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LoginFbDto? loginFbDtoFromJson(String str) => LoginFbDto.fromJson(json.decode(str));

String loginFbDtoToJson(LoginFbDto? data) => json.encode(data!.toJson());

class LoginFbDto {
    LoginFbDto({
        required this.facebookId,
    });

    String? facebookId;

    factory LoginFbDto.fromJson(Map<String, dynamic> json) => LoginFbDto(
        facebookId: json["FacebookID"],
    );

    Map<String, dynamic> toJson() => {
        "FacebookID": facebookId,
    };
}

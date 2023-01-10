// To parse this JSON data, do
//
//     final registerFbdto = registerFbdtoFromJson(jsonString);

import 'dart:convert';

RegisterFbdto? registerFbdtoFromJson(String str) => RegisterFbdto.fromJson(json.decode(str));

String registerFbdtoToJson(RegisterFbdto? data) => json.encode(data!.toJson());

class RegisterFbdto {
    RegisterFbdto({
        required this.username,
        required this.email,
        required this.image,
    });

    String? username;
    String? email;
    String? image;

    factory RegisterFbdto.fromJson(Map<String, dynamic> json) => RegisterFbdto(
        username: json["Username"],
        email: json["Email"],
        image: json["Image"],
    );

    Map<String, dynamic> toJson() => {
        "Username": username,
        "Email": email,
        "Image": image,
    };
}

// To parse this JSON data, do
//
//     final registerCusDto = registerCusDtoFromJson(jsonString);

import 'dart:convert';

RegisterCusDto registerCusDtoFromJson(String str) => RegisterCusDto.fromJson(json.decode(str));

String registerCusDtoToJson(RegisterCusDto data) => json.encode(data.toJson());

class RegisterCusDto {
    String username;
    String password;
    String email;
    String fullName;
    String birthday;
    String gender;
    String phone;
    String image;
    int weight;
    int height;

    RegisterCusDto({
        required this.username,
        required this.password,
        required this.email,
        required this.fullName,
        required this.birthday,
        required this.gender,
        required this.phone,
        required this.image,
        required this.weight,
        required this.height,
    });

    factory RegisterCusDto.fromJson(Map<String, dynamic> json) => RegisterCusDto(
        username: json["Username"],
        password: json["Password"],
        email: json["Email"],
        fullName: json["FullName"],
        birthday: json["Birthday"],
        gender: json["Gender"],
        phone: json["Phone"],
        image: json["Image"],
        weight: json["weight"],
        height: json["height"],
    );

    Map<String, dynamic> toJson() => {
        "Username": username,
        "Password": password,
        "Email": email,
        "FullName": fullName,
        "Birthday": birthday,
        "Gender": gender,
        "Phone": phone,
        "Image": image,
        "weight": weight,
        "height": height,
    };
}

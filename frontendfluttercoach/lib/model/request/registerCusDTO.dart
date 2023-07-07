// To parse this JSON data, do
//
//     final registerCusDto = registerCusDtoFromJson(jsonString);

import 'dart:convert';

RegisterCusDto? registerCusDtoFromJson(String str) => RegisterCusDto.fromJson(json.decode(str));

String registerCusDtoToJson(RegisterCusDto? data) => json.encode(data!.toJson());

class RegisterCusDto {
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
        required this.price,
        required this.facebookId,
    });

    String? username;
    String? password;
    String? email;
    String? fullName;
    String? birthday;
    String? gender;
    String? phone;
    String? image;
    int? weight;
    int? height;
    int? price;
    String? facebookId;

    factory RegisterCusDto.fromJson(Map<String, dynamic> json) => RegisterCusDto(
        username: json["Username"],
        password: json["Password"],
        email: json["Email"],
        fullName: json["FullName"],
        birthday: json["Birthday"],
        gender: json["Gender"],
        phone: json["Phone"],
        image: json["Image"],
        weight: json["Weight"],
        height: json["Height"],
        price: json["Price"],
        facebookId: json["FacebookID"],
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
        "Weight": weight,
        "Height": height,
        "Price": price,
        "FacebookID": facebookId,
    };
}

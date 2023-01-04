// To parse this JSON data, do
//
//     final registerCoachDto = registerCoachDtoFromJson(jsonString);

import 'dart:convert';

RegisterCoachDto registerCoachDtoFromJson(String str) => RegisterCoachDto.fromJson(json.decode(str));

String registerCoachDtoToJson(RegisterCoachDto data) => json.encode(data.toJson());

class RegisterCoachDto {
    RegisterCoachDto({
        required this.username,
        required this.password,
        required this.email,
        required this.fullName,
        required this.birthday,
        required this.gender,
        required this.phone,
        required this.image,
        required this.qualification,
        required this.property,
    });

    String username;
    String password;
    String email;
    String fullName;
    String birthday;
    String gender;
    String phone;
    String image;
    String qualification;
    String property;

    factory RegisterCoachDto.fromJson(Map<String, dynamic> json) => RegisterCoachDto(
        username: json["Username"],
        password: json["Password"],
        email: json["Email"],
        fullName: json["FullName"],
        birthday: json["Birthday"],
        gender: json["Gender"],
        phone: json["Phone"],
        image: json["Image"],
        qualification: json["qualification"],
        property: json["property"],
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
        "qualification": qualification,
        "property": property,
    };
}

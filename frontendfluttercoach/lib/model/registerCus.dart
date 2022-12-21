// To parse this JSON data, do
//
//     final registerCusFromJson = registerCusFromJsonFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<RegisterCusFromJson> registerCusFromJsonFromJson(String str) => List<RegisterCusFromJson>.from(json.decode(str).map((x) => RegisterCusFromJson.fromJson(x)));

String registerCusFromJsonToJson(List<RegisterCusFromJson> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RegisterCusFromJson {
    RegisterCusFromJson({
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
    });

    String username;
    String password;
    String email;
    String fullName;
    DateTime birthday;
    String gender;
    String phone;
    String image;
    int weight;
    int height;
    int price;

    factory RegisterCusFromJson.fromJson(Map<String, dynamic> json) => RegisterCusFromJson(
        username: json["Username"],
        password: json["Password"],
        email: json["Email"],
        fullName: json["FullName"],
        birthday: DateTime.parse(json["Birthday"]),
        gender: json["Gender"],
        phone: json["Phone"],
        image: json["Image"],
        weight: json["Weight"],
        height: json["Height"],
        price: json["Price"],
    );

    Map<String, dynamic> toJson() => {
        "Username": username,
        "Password": password,
        "Email": email,
        "FullName": fullName,
        "Birthday": birthday.toIso8601String(),
        "Gender": gender,
        "Phone": phone,
        "Image": image,
        "Weight": weight,
        "Height": height,
        "Price": price,
    };
    //RegisterCusFromJson({this.username,required this.password,required this.email,required this.fullName,required this.birthday,required this.gender,required this.phone,required this.image,required this.weight,required this.height,required this.price});
}

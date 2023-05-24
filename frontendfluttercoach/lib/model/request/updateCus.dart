// To parse this JSON data, do
//
//     final updateCustomer = updateCustomerFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<UpdateCustomer> updateCustomerFromJson(String str) => List<UpdateCustomer>.from(json.decode(str).map((x) => UpdateCustomer.fromJson(x)));

String updateCustomerToJson(List<UpdateCustomer> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UpdateCustomer {
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

    UpdateCustomer({
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

    factory UpdateCustomer.fromJson(Map<String, dynamic> json) => UpdateCustomer(
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
    );

    Map<String, dynamic> toJson() => {
        "Username": username,
        "Password": password,
        "Email": email,
        "FullName": fullName,
        "Birthday": "${birthday.year.toString().padLeft(4, '0')}-${birthday.month.toString().padLeft(2, '0')}-${birthday.day.toString().padLeft(2, '0')}",
        "Gender": gender,
        "Phone": phone,
        "Image": image,
        "Weight": weight,
        "Height": height,
    };
}

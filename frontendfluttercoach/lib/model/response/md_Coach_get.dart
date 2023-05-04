// To parse this JSON data, do
//
//     final coach = coachFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Coach coachFromJson(String str) => Coach.fromJson(json.decode(str));

String coachToJson(Coach data) => json.encode(data.toJson());

class Coach {
    Coach({
        required this.cid,
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
        required this.facebookId,
        required this.chats,
    });

    int cid;
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
    String facebookId;
    dynamic chats;

    factory Coach.fromJson(Map<String, dynamic> json) => Coach(
        cid: json["Cid"],
        username: json["Username"],
        password: json["Password"],
        email: json["Email"],
        fullName: json["FullName"],
        birthday: json["Birthday"],
        gender: json["Gender"],
        phone: json["Phone"],
        image: json["Image"],
        qualification: json["Qualification"],
        property: json["Property"],
        facebookId: json["FacebookID"],
        chats: json["Chats"],
    );

    Map<String, dynamic> toJson() => {
        "Cid": cid,
        "Username": username,
        "Password": password,
        "Email": email,
        "FullName": fullName,
        "Birthday": birthday,
        "Gender": gender,
        "Phone": phone,
        "Image": image,
        "Qualification": qualification,
        "Property": property,
        "FacebookID": facebookId,
        "Chats": chats,
    };
}

// To parse this JSON data, do
//
//     final coach = coachFromJson(jsonString);

import 'dart:convert';

List<Coach> coachFromJson(String str) => List<Coach>.from(json.decode(str).map((x) => Coach.fromJson(x)));

String coachToJson(List<Coach> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Coach {
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
    int price;
    String bankName;
    String idCard;

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
        required this.price,
        required this.bankName,
        required this.idCard,
    });

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
        price: json["Price"],
        bankName: json["BankName"],
        idCard: json["IdCard"],
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
        "Price": price,
        "BankName": bankName,
        "IdCard": idCard,
    };
}

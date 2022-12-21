// To parse this JSON data, do
//
//     final coach = coachFromJson(jsonString);

import 'dart:convert';

List<Coach> coachFromJson(String str) => List<Coach>.from(json.decode(str).map((x) => Coach.fromJson(x)));

String coachToJson(List<Coach> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Coach {
    Coach({
        required this.uid,
        required this.aliasName,
        required this.password,
        required this.email,
        required this.fullName,
        required this.birthday,
        required this.gender,
        required this.phone,
        required this.image,
        required this.weight,
        required this.height,
        required this.facebookId,
        required this.price,
        required this.buying,
    });

    int uid;
    String aliasName;
    String password;
    String email;
    String fullName;
    String birthday;
    String gender;
    String phone;
    String image;
    int weight;
    int height;
    String facebookId;
    int price;
    dynamic buying;

    factory Coach.fromJson(Map<String, dynamic> json) => Coach(
        uid: json["Uid"],
        aliasName: json["AliasName"],
        password: json["Password"],
        email: json["Email"],
        fullName: json["FullName"],
        birthday: json["Birthday"],
        gender: json["Gender"],
        phone: json["Phone"],
        image: json["Image"],
        weight: json["Weight"],
        height: json["Height"],
        facebookId: json["FacebookID"],
        price: json["Price"],
        buying: json["Buying"],
    );

    Map<String, dynamic> toJson() => {
        "Uid": uid,
        "AliasName": aliasName,
        "Password": password,
        "Email": email,
        "FullName": fullName,
        "Birthday": birthday,
        "Gender": gender,
        "Phone": phone,
        "Image": image,
        "Weight": weight,
        "Height": height,
        "FacebookID": facebookId,
        "Price": price,
        "Buying": buying,
    };
}

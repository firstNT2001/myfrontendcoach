// To parse this JSON data, do
//
//     final customer = customerFromJson(jsonString);

import 'dart:convert';

Customer customerFromJson(String str) => Customer.fromJson(json.decode(str));

String customerToJson(Customer data) => json.encode(data.toJson());

class Customer {
    Customer({
        required this.uid,
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
        required this.facebookId,
        required this.price,
        required this.buying,
    });

    int uid;
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
    String facebookId;
    int price;
    dynamic buying;

    factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        uid: json["Uid"],
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
        facebookId: json["FacebookID"],
        price: json["Price"],
        buying: json["Buying"],
    );

    Map<String, dynamic> toJson() => {
        "Uid": uid,
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
        "FacebookID": facebookId,
        "Price": price,
        "Buying": buying,
    };
}

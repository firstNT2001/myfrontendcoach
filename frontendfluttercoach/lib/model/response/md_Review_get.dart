// To parse this JSON data, do
//
//     final modelReview = modelReviewFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<ModelReview> modelReviewFromJson(String str) => List<ModelReview>.from(json.decode(str).map((x) => ModelReview.fromJson(x)));

String modelReviewToJson(List<ModelReview> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelReview {
    int rid;
    int customerId;
    int courseId;
    String details;
    int score;
    int weight;
    Customer customer;

    ModelReview({
        required this.rid,
        required this.customerId,
        required this.courseId,
        required this.details,
        required this.score,
        required this.weight,
        required this.customer,
    });

    factory ModelReview.fromJson(Map<String, dynamic> json) => ModelReview(
        rid: json["Rid"],
        customerId: json["CustomerID"],
        courseId: json["CourseID"],
        details: json["Details"],
        score: json["Score"],
        weight: json["Weight"],
        customer: Customer.fromJson(json["Customer"]),
    );

    Map<String, dynamic> toJson() => {
        "Rid": rid,
        "CustomerID": customerId,
        "CourseID": courseId,
        "Details": details,
        "Score": score,
        "Weight": weight,
        "Customer": customer.toJson(),
    };
}

class Customer {
    int uid;
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
    String facebookId;
    int price;

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
    });

    factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        uid: json["Uid"],
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
        facebookId: json["FacebookID"],
        price: json["Price"],
    );

    Map<String, dynamic> toJson() => {
        "Uid": uid,
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
        "FacebookID": facebookId,
        "Price": price,
    };
}

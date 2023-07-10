// To parse this JSON data, do
//
//     final modelBuying = modelBuyingFromJson(jsonString);


import 'dart:convert';

import 'md_Course_get.dart';
import 'md_coach_course_get.dart';

List<Buying> modelBuyingFromJson(String str) => List<Buying>.from(json.decode(str).map((x) => Buying.fromJson(x)));

String modelBuyingToJson(List<Buying> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Buying {
    int bid;
    int customerId;
    String buyDateTime;
    int courseId;
    Customer customer;
    List<Course> courses;

    Buying({
        required this.bid,
        required this.customerId,
        required this.buyDateTime,
        required this.courseId,
        required this.customer,
        required this.courses,
    });

    factory Buying.fromJson(Map<String, dynamic> json) => Buying(
        bid: json["Bid"],
        customerId: json["CustomerID"],
        buyDateTime: json["BuyDateTime"],
        courseId: json["CourseID"],
        customer: Customer.fromJson(json["Customer"]),
        courses: List<Course>.from(json["Courses"].map((x) => Course.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Bid": bid,
        "CustomerID": customerId,
        "BuyDateTime": buyDateTime,
        "CourseID": courseId,
        "Customer": customer.toJson(),
        "Courses": List<dynamic>.from(courses.map((x) => x.toJson())),
    };
}

class BuyingCustomer {
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
    dynamic chats;
    dynamic buying;

    BuyingCustomer({
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
        required this.chats,
        required this.buying,
    });

    factory BuyingCustomer.fromJson(Map<String, dynamic> json) => BuyingCustomer(
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
        chats: json["Chats"],
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
        "Chats": chats,
        "Buying": buying,
    };
}


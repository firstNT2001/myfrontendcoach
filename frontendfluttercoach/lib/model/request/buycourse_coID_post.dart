// To parse this JSON data, do
//
//     final buyCoursecoIdPost = buyCoursecoIdPostFromJson(jsonString);


import 'dart:convert';

BuyCoursecoIdPost buyCoursecoIdPostFromJson(String str) => BuyCoursecoIdPost.fromJson(json.decode(str));

String buyCoursecoIdPostToJson(BuyCoursecoIdPost data) => json.encode(data.toJson());

class BuyCoursecoIdPost {
    int customerId;
    String buyDateTime;
    String image;

    BuyCoursecoIdPost({
        required this.customerId,
        required this.buyDateTime,
        required this.image,
    });

    factory BuyCoursecoIdPost.fromJson(Map<String, dynamic> json) => BuyCoursecoIdPost(
        customerId: json["CustomerID"],
        buyDateTime: json["BuyDateTime"],
        image: json["Image"],
    );

    Map<String, dynamic> toJson() => {
        "CustomerID": customerId,
        "BuyDateTime": buyDateTime,
        "Image": image,
    };
}

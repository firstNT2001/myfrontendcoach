// To parse this JSON data, do
//
//     final modelBuying = modelBuyingFromJson(jsonString);

import 'dart:convert';

ModelBuying modelBuyingFromJson(String str) => ModelBuying.fromJson(json.decode(str));

String modelBuyingToJson(ModelBuying data) => json.encode(data.toJson());

class ModelBuying {
    int bid;
    int customerId;
    String buyDateTime;
    String image;

    ModelBuying({
        required this.bid,
        required this.customerId,
        required this.buyDateTime,
        required this.image,
    });

    factory ModelBuying.fromJson(Map<String, dynamic> json) => ModelBuying(
        bid: json["Bid"],
        customerId: json["CustomerID"],
        buyDateTime: json["BuyDateTime"],
        image: json["Image"],
    );

    Map<String, dynamic> toJson() => {
        "Bid": bid,
        "CustomerID": customerId,
        "BuyDateTime": buyDateTime,
        "Image": image,
    };
}

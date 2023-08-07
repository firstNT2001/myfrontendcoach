// To parse this JSON data, do
//
//     final modelAmountclip = modelAmountclipFromJson(jsonString);

import 'dart:convert';

ModelAmountclip modelAmountclipFromJson(String str) => ModelAmountclip.fromJson(json.decode(str));

String modelAmountclipToJson(ModelAmountclip data) => json.encode(data.toJson());

class ModelAmountclip {
    int amount;

    ModelAmountclip({
        required this.amount,
    });

    factory ModelAmountclip.fromJson(Map<String, dynamic> json) => ModelAmountclip(
        amount: json["amount"],
    );

    Map<String, dynamic> toJson() => {
        "amount": amount,
    };
}

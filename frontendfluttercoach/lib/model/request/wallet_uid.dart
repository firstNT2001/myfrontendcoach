// To parse this JSON data, do
//
//     final walletUser = walletUserFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

WalletUser walletUserFromJson(String str) => WalletUser.fromJson(json.decode(str));

String walletUserToJson(WalletUser data) => json.encode(data.toJson());

class WalletUser {
    double money;
    String referenceNo;

    WalletUser({
        required this.money,
        required this.referenceNo,
    });

    factory WalletUser.fromJson(Map<String, dynamic> json) => WalletUser(
        money: json["money"]?.toDouble(),
        referenceNo: json["referenceNo"],
    );

    Map<String, dynamic> toJson() => {
        "money": money,
        "referenceNo": referenceNo,
    };
}

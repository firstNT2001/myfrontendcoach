// To parse this JSON data, do
//
//     final historywallet = historywalletFromJson(jsonString);

import 'dart:convert';

List<Historywallet> historywalletFromJson(String str) => List<Historywallet>.from(json.decode(str).map((x) => Historywallet.fromJson(x)));

String historywalletToJson(List<Historywallet> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Historywallet {
    int wid;
    int customerId;
    int money;
    String status;
    int amount;
    String date;
    String time;

    Historywallet({
        required this.wid,
        required this.customerId,
        required this.money,
        required this.status,
        required this.amount,
        required this.date,
        required this.time,
    });

    factory Historywallet.fromJson(Map<String, dynamic> json) => Historywallet(
        wid: json["Wid"],
        customerId: json["CustomerID"],
        money: json["Money"],
        status: json["Status"],
        amount: json["Amount"],
        date: json["Date"],
        time: json["Time"],
    );

    Map<String, dynamic> toJson() => {
        "Wid": wid,
        "CustomerID": customerId,
        "Money": money,
        "Status": status,
        "Amount": amount,
        "Date": date,
        "Time": time,
    };
}

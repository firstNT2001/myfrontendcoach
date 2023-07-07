// To parse this JSON data, do
//
//     final responseGbprime = responseGbprimeFromJson(jsonString);

import 'dart:convert';

ResponseGbprime responseGbprimeFromJson(String str) => ResponseGbprime.fromJson(json.decode(str));

String responseGbprimeToJson(ResponseGbprime data) => json.encode(data.toJson());

class ResponseGbprime {
    int amount;
    String retryFlag;
    String referenceNo;
    String gbpReferenceNo;
    String currencyCode;
    String resultCode;
    int totalAmount;
    double fee;
    double vat;
    int thbAmount;
    String customerName;
    String date;
    String time;
    String paymentType;

    ResponseGbprime({
        required this.amount,
        required this.retryFlag,
        required this.referenceNo,
        required this.gbpReferenceNo,
        required this.currencyCode,
        required this.resultCode,
        required this.totalAmount,
        required this.fee,
        required this.vat,
        required this.thbAmount,
        required this.customerName,
        required this.date,
        required this.time,
        required this.paymentType,
    });

    factory ResponseGbprime.fromJson(Map<String, dynamic> json) => ResponseGbprime(
        amount: json["amount"],
        retryFlag: json["retryFlag"],
        referenceNo: json["referenceNo"],
        gbpReferenceNo: json["gbpReferenceNo"],
        currencyCode: json["currencyCode"],
        resultCode: json["resultCode"],
        totalAmount: json["totalAmount"],
        fee: json["fee"]?.toDouble(),
        vat: json["vat"]?.toDouble(),
        thbAmount: json["thbAmount"],
        customerName: json["customerName"],
        date: json["date"],
        time: json["time"],
        paymentType: json["paymentType"],
    );

    Map<String, dynamic> toJson() => {
        "amount": amount,
        "retryFlag": retryFlag,
        "referenceNo": referenceNo,
        "gbpReferenceNo": gbpReferenceNo,
        "currencyCode": currencyCode,
        "resultCode": resultCode,
        "totalAmount": totalAmount,
        "fee": fee,
        "vat": vat,
        "thbAmount": thbAmount,
        "customerName": customerName,
        "date": date,
        "time": time,
        "paymentType": paymentType,
    };
}

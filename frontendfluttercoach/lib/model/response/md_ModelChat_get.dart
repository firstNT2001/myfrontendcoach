// To parse this JSON data, do
//
//     final modelChat = modelChatFromJson(jsonString);

import 'dart:convert';

ModelChat modelChatFromJson(String str) => ModelChat.fromJson(json.decode(str));

String modelChatToJson(ModelChat data) => json.encode(data.toJson());

class ModelChat {
    int chId;
    int customerId;
    int buyingId;
    int coachId;
    String message;

    ModelChat({
        required this.chId,
        required this.customerId,
        required this.buyingId,
        required this.coachId,
        required this.message,
    });

    factory ModelChat.fromJson(Map<String, dynamic> json) => ModelChat(
        chId: json["ChID"],
        customerId: json["CustomerID"],
        buyingId: json["BuyingID"],
        coachId: json["CoachID"],
        message: json["Message"],
    );

    Map<String, dynamic> toJson() => {
        "ChID": chId,
        "CustomerID": customerId,
        "BuyingID": buyingId,
        "CoachID": coachId,
        "Message": message,
    };
}

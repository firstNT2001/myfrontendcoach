// To parse this JSON data, do
//
//     final modelCidAndUid = modelCidAndUidFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ModelCidAndUid? modelCidAndUidFromJson(String str) => ModelCidAndUid.fromJson(json.decode(str));

String modelCidAndUidToJson(ModelCidAndUid? data) => json.encode(data!.toJson());

class ModelCidAndUid {
    ModelCidAndUid({
        required this.cid,
        required this.uid,
    });

    int? cid;
    int? uid;

    factory ModelCidAndUid.fromJson(Map<String, dynamic> json) => ModelCidAndUid(
        cid: json["Cid"],
        uid: json["Uid"],
    );

    Map<String, dynamic> toJson() => {
        "Cid": cid,
        "Uid": uid,
    };
}

// To parse this JSON data, do
//
//     final dayDayIdPut = dayDayIdPutFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

DayDayIdPut dayDayIdPutFromJson(String str) => DayDayIdPut.fromJson(json.decode(str));

String dayDayIdPutToJson(DayDayIdPut data) => json.encode(data.toJson());

class DayDayIdPut {
    int sequence;

    DayDayIdPut({
        required this.sequence,
    });

    factory DayDayIdPut.fromJson(Map<String, dynamic> json) => DayDayIdPut(
        sequence: json["Sequence"],
    );

    Map<String, dynamic> toJson() => {
        "Sequence": sequence,
    };
}

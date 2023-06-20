


import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../model/request/rq_gbprime.dart';

class getQrcode extends StatefulWidget {
  getQrcode({super.key, required this.money, required this.refNo});
  late double money;
  late String refNo;

  @override
  State<getQrcode> createState() => _getQrcodeState();
}

class _getQrcodeState extends State<getQrcode> {
  late Future<void> loadDataMethod;
  var model;
  double _money = 0;
  String _refNo = "";
  String _token =
      "M1Cm5LbSMxNBWFTSs/+1Bvx0lY762Jsg2tZRNsrA84BKk7fBphv554YSg5oJFjYu7t7o6EZqDEws5gyseCPsenqzjQ14wr0ECiKSF0Hirtl3F2Bmexc+qqkSdtE37vPRTrh5AdDZU09BavRKb/jSRT1bH4pr6kimy5d0RDpevZJd8clY";
  String _backgroundUrl = "https://cslab.it.msu.ac.th/gbprimepay/callback.php";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _money = widget.money;
    _refNo = widget.refNo;
    loadDataMethod = loadQr();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(children: [showQr()],)),
    );
  }
  Future<RqGbprime> loadQr() async {
   String url = 'https://api.gbprimepay.com/v3/qrcode';

   Map<String, dynamic> body = {
    "token": _token,
      "referenceNo": _refNo,
      "backgroundUrl": _backgroundUrl,
      "amount": _money,
    };

   print("backgroundUrl " + _backgroundUrl + " referenceNo " + _refNo + " " + body.toString());
 final dio = Dio();
   final response = await dio.post(
      url,
      data: {"token": _token,
          "referenceNo": _refNo,
          "backgroundUrl": _backgroundUrl,
          "amount": _money},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

   if (response.statusCode == 200) {
     // If the call to the server was successful, parse the JSON
     print(response.data);
     return RqGbprime.fromJson(json.decode(response.data));
   } else {
     // If that call was not successful, throw an error.
     throw Exception('Failed to load post');
   }
 }
 Widget showQr(){
  return FutureBuilder(
      future: loadDataMethod,
      builder: (context, snapshot) {
         if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Column(
            children: [
                Text("data"),
            ],
          );
        }});
 }

  // Future<void> loadQr() async {
  //   final dio = Dio();
  //   String url = 'https://api.gbprimepay.com/v3/qrcode';
  //   log(_token);
  //   final parameters = <String, dynamic>{
  //     "token": _token,
  //     "referenceNo": _refNo,
  //     "backgroundUrl": _backgroundUrl,
  //     "amount": _money,
  //   };
  //   final dioRes = await dio.post(
  //     url,
  //     data: parameters,
  //     options: Options(contentType: Headers.formUrlEncodedContentType),
  //   );
  //   print('statusCode: ${dioRes.statusCode} data: ${dioRes.data}');
  // }

  // Future<void> loadQr() async {
  //   model = RqGbprime(token: _token, referenceNo: _refNo, backgroundUrl: _backgroundUrl, amount: _money);
  //   var responseapi = await https.p

//     String url = 'https://api.gbprimepay.com/v3/qrcode';
//     var dio = new Dio();
//     // Instance level
//     dio.options.contentType = Headers.formUrlEncodedContentType;
// // or only works once
//      Response responses = await dio.post(
//       url,
//       data: {"token": _token,
//           "referenceNo": _refNo,
//           "backgroundUrl": _backgroundUrl,
//           "amount": _money},
//       options: Options(contentType: Headers.formUrlEncodedContentType),
//     );
//     log(jsonDecode(responses.data));
//     return RqGbprime(token: _token, referenceNo: _refNo, backgroundUrl: _backgroundUrl, amount: _money);
//     Response response = await dio.post(url,
//         data: {
//           "token": _token,
//           "referenceNo": _refNo,
//           "backgroundUrl": _backgroundUrl,
//           "amount": _money
//         },
//         // Instance level
// dio.options.contentType = Headers.formUrlEncodedContentType;

//     if (response.statusCode == 200) {
//       // If the call to the server was successful, parse the JSON
//       log(response.data);

//     } else {
//       // If that call was not successful, throw an error.
//       throw Exception('Failed to load post');
//     }
  // }
}

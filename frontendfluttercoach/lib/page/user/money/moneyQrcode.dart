import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/response/md_Result.dart';

import '../../../service/wallet.dart';
import '../profileUser.dart';

class getQrcode extends StatefulWidget {
  const getQrcode({super.key, required this.money, required this.refNo});
  final double money;
  final String refNo;

  @override
  State<getQrcode> createState() => _getQrcodeState();
}

class _getQrcodeState extends State<getQrcode> {
  late Future<void> loadDataMethod;
  late WalletService walletService;
  late ModelResult moduleResult;
  var updatetWallet;
  var model;
  double _money = 0;
  String _refNo = "";
  String _token =
      "M1Cm5LbSMxNBWFTSs/+1Bvx0lY762Jsg2tZRNsrA84BKk7fBphv554YSg5oJFjYu7t7o6EZqDEws5gyseCPsenqzjQ14wr0ECiKSF0Hirtl3F2Bmexc+qqkSdtE37vPRTrh5AdDZU09BavRKb/jSRT1bH4pr6kimy5d0RDpevZJd8clY";
  String _backgroundUrl = "https://cslab.it.msu.ac.th/gbprimepay/callback.php";
  List<int> _imagebytes = [];
  String base64string = "";
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
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: showQr(),
          )
        ],
      )),
    );
  }

  Future<void> loadQr() async {
    String url = 'https://api.gbprimepay.com/v3/qrcode';

    Map<String, dynamic> body = {
      "token": _token,
      "referenceNo": _refNo,
      "backgroundUrl": _backgroundUrl,
      "amount": _money,
    };

    print("backgroundUrl " +
        _backgroundUrl +
        " referenceNo " +
        _refNo +
        " " +
        body.toString());
    try {
      final dio = Dio();
      final response = await dio.post(
        url,
        data: body,
        options: Options(
            contentType: Headers.formUrlEncodedContentType,
            responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        log("A");
        _imagebytes = response.data;
        log("B");
        // print(response.data);
        //log("showimg"+_imagebytes);
        //return RqGbprime.fromJson(json.decode(response.data));
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    } catch (err) {
      log('111' + err.toString());
    }
  }

  Widget showQr() {
    return FutureBuilder(
        future: loadDataMethod,
        builder: (context, snapshot) {
          //1. respon.data to string
          //log("_imagebytes"+_imagebytes.toString());
          String base64string = base64.encode(_imagebytes);
          //log("base64string"+base64string.toString());
          //2. webType + step1
          String _imagetype = 'data:image/png;base64,' + base64string;
          //log("_imagetype : "+_imagetype.toString());
          //3. convert
          //final List<int> codeUnits = _imagetype.codeUnits;
          //log("codeUnits : "+codeUnits.toString());
          //final Uint8List unit8List = Uint8List.fromList(codeUnits);

          UriData imgQr = Uri.parse(_imagetype).data!;
          //log("unit8List"+unit8List.toString());
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return SizedBox(
              height: 450,
              width: 350,
              child: Card(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        child: SizedBox(
                            width: 250,
                            height: 380,
                            child: Image.memory(
                              imgQr.contentAsBytes(),
                              fit: BoxFit.cover,
                            )),
                      ),
                      FilledButton(
                          onPressed: () {
                            
                            Get.to(() => ProfileUser());
                          },
                          child: Text("กลับสู่หน้าหลัก"))
                    ],
                  ),
                ),
              ),
            );
          }
        });
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

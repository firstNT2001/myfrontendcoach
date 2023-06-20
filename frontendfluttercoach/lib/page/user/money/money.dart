import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';


import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/service/wallet.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../model/request/wallet_uid.dart';
import '../../../model/response/md_Result.dart';
import '../../../service/provider/appdata.dart';
import 'moneyQrcode.dart';

class addCoin extends StatefulWidget {
  const addCoin({super.key});

  @override
  State<addCoin> createState() => _addCoinState();
}

class _addCoinState extends State<addCoin> {
  late WalletService walletService;
  late ModelResult moduleResult;
  int uid = 0;

  var insertWallet;

  final _money = TextEditingController();

  int timestamp = DateTime.now().millisecondsSinceEpoch;
  String txtUid = "";
  String txtTimestamp = "";
  String referenceNo = "";

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    walletService =
        WalletService(Dio(), baseUrl: context.read<AppData>().baseurl);
    uid = context.read<AppData>().uid;
    log(uid.toString());
    txtUid = uid.toString();
    txtTimestamp = timestamp.toString();
    referenceNo = txtUid+txtTimestamp;
    log("reffNoo :"+timestamp.toString());
    log("reffNoo2 :"+referenceNo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("เติมเงิน"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child:  Text("กรุณาใส่จำนวนเงิน",style: Theme.of(context).textTheme.bodyLarge),
            ),
            SizedBox(
              width: 200,
              child: TextFormField(
                controller: _money,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18),
              child: ElevatedButton(onPressed: () async {
                //Double money = double.parse(_money.text);

                WalletUser walletUser = WalletUser(
                  money: double.parse(_money.text), 
                  referenceNo: referenceNo);
                  log(jsonEncode(walletUser));
                  insertWallet = await  walletService.insertWallet(
                    uid.toString(), walletUser);
                    moduleResult = insertWallet.data;
                    log(jsonEncode(moduleResult.result));
                      if (moduleResult.result == "0") {
                        // ignore: use_build_context_synchronously
                        //showDialogRowsAffected(context, "บันทึกสำเร็จ");
                       Get.to(() =>  getQrcode(money: double.parse(_money.text),refNo: referenceNo,));
                          
                      } else{
                        CircularProgressIndicator();
                      }
              }, child: Text("เติมเงิน",style: Theme.of(context).textTheme.bodyLarge
,)),
            )
          ],
        ),
      ),
    );
  }
}

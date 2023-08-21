import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/service/wallet.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../../model/request/wallet_uid.dart';
import '../../../model/response/md_Result.dart';
import '../../../service/provider/appdata.dart';
import '../../../widget/textField/wg_textField_int.dart';
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
  bool _isvisible = false;
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
    referenceNo = txtUid + txtTimestamp;
    log("reffNoo :" + timestamp.toString());
    log("reffNoo2 :" + referenceNo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.chevronLeft,
          ),
          onPressed: () {
            // Get.to(() => DaysCoursePage(
            //       coID: context.read<AppData>().coID.toString(),
            //       isVisible: widget.isVisible,
            //     ));
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("กรุณาใส่จำนวนเงิน",
                style: Theme.of(context).textTheme.titleLarge),
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child:
                  WidgetTextFieldIntnotmax(controller: _money, labelText: ''),
            ),
            Visibility(
              visible: _isvisible,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 10, left: 20, right: 23),
                    child: Text(
                      "ขั้นต่ำ 1 บาท",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18),
              child: FilledButton(
                  onPressed: () async {
                    //Double money = double.parse(_money.text);
                    log("inputmoneyT" + _money.text);
                    double inputmoney = double.parse(_money.text);
                    log("inputmoney" + inputmoney.toString());
                    if (inputmoney < 1 || _money.text.isEmpty) {
                      setState(() {
                        _isvisible = true;
                      });
                    } else {
                      WalletUser walletUser = WalletUser(
                          money: double.parse(_money.text),
                          referenceNo: referenceNo);
                      log(jsonEncode(walletUser));
                      insertWallet = await walletService.insertWallet(
                          uid.toString(), walletUser);
                      moduleResult = insertWallet.data;
                      log(jsonEncode(moduleResult.result));
                      if (moduleResult.result == "1") {
                        // ignore: use_build_context_synchronously
                        //showDialogRowsAffected(context, "บันทึกสำเร็จ");
                        pushNewScreen(
                          context,
                          screen: getQrcode(
                            money: double.parse(_money.text),
                            refNo: referenceNo,
                          ),
                          withNavBar: true,
                        );
                      } else {
                        CircularProgressIndicator();
                      }
                    }
                  },
                  child: Text("เติมเงิน", style: TextStyle(fontSize: 16))),
            ),
          ],
        ),
      ),
    );
  }
}

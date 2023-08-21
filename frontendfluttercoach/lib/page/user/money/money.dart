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
  bool _isvisibleText = false;
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
            Navigator.pop(context);
          },
        ),
        title: Text(
          "เติมเงิน",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Color.fromARGB(255, 255, 225, 194),
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: ExactAssetImage("assets/images/wall.jpg"),
            //     fit: BoxFit.fitWidth,
            //   ),
            // ),
          ),

          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.2,
                left: 25,
                right: 25),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 196, 196, 196),
                      blurRadius: 20.0,
                      spreadRadius: 1,
                      offset: Offset(
                        0,
                        1,
                      ),
                    )
                  ],
                  color: Color.fromARGB(255, 255, 183, 106),
                  borderRadius: BorderRadius.circular(40)
                  //more than 50% of width makes circle
                  ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.height * 0.12,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: ExactAssetImage("assets/images/money.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(
                    //       width: MediaQuery.of(context).size.width * 0.45,
                    //       height: MediaQuery.of(context).size.height * 0.18,
                    //       child: Image.asset("assets/images/money.png")),

                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text("กรุณาใส่จำนวนเงิน",
                          style: Theme.of(context).textTheme.titleLarge),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20, left: 20),
                      child: WidgetTextFieldIntnotmax(
                          controller: _money, labelText: ''),
                    ),
                    Visibility(
                      visible: _isvisible,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 10, left: 20, right: 23),
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
                    
                    Visibility(
                      visible: _isvisibleText,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 10, left: 20, right: 23),
                            child: Text(
                              "กรุณากรอกข้อมูลให้ครบ",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: FilledButton(
                          onPressed: () async {
                            //Double money = double.parse(_money.text);
                           
                            log("inputmoneyT" + _money.text);
                             double inputmoney = double.tryParse(_money.text) ?? 0;
                            log("inputmoney" + inputmoney.toString());
                            if (inputmoney < 1 || _money.text.isEmpty) {
                              setState(() {
                                _isvisible = true;
                                _isvisibleText =false;
                              });
                            }else if( _money.text.isEmpty){
                              log("AA");
                              setState(() {
                                _isvisible = false;
                                _isvisibleText =true;
                              });
                            } else if(_money.text.isNotEmpty) {
                              log("BB");
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
                          child:
                              Text("เติมเงิน", style: TextStyle(fontSize: 16))),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

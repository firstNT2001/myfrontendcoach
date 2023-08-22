import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/page/user/money/widgethistory/widget_history.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:retrofit/retrofit.dart';

import '../../../model/response/md_Customer_get.dart';
import '../../../model/response/md_historyWallet_get.dart';
import '../../../service/customer.dart';
import '../../../service/provider/appdata.dart';
import '../../../service/wallet.dart';
import 'money.dart';

class HistoryWallet extends StatefulWidget {
  const HistoryWallet({super.key});

  @override
  State<HistoryWallet> createState() => _HistoryWalletState();
}

class _HistoryWalletState extends State<HistoryWallet> {
  late int uid;
  late CustomerService customerService;
  List<Customer> customer = [];

  late Future<void> loadDataMethod;
  late int money = 0;
  @override
  void initState() {
    super.initState();
    uid = context.read<AppData>().uid;
    log("userID" + uid.toString());
    customerService =
        CustomerService(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async{
              setState(() {
                loadDataMethod = loadData();
              });
            },
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              color: const Color.fromARGB(255, 255, 233, 169),
            ),
            // Container(
            //   height: MediaQuery.of(context).size.height * 0.25,
            //   decoration: const BoxDecoration(),
            //   child: ClipRRect(
            //     borderRadius: const BorderRadius.only(
            //       bottomLeft: Radius.circular(40.0),
            //       bottomRight: Radius.circular(40.0),
            //     ),
            //     child: Container(
            //       decoration:
            //           BoxDecoration(color: Color.fromARGB(255, 247, 142, 30)),
            //       height: MediaQuery.of(context).size.height * 0.218,
            //     ),
            //   ),
            // ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                          onPressed: () {
                            pushNewScreen(
                              context,
                              screen: const addCoin(),
                              withNavBar: true,
                            );
                          },
                          icon: const Icon(
                            FontAwesomeIcons.circlePlus,
                            size: 40,color: Color.fromARGB(255, 247, 142, 30),
                          )),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: showMoney(),
                ),
                
                Expanded(
                  child: WidgetHistory(
                    uid: uid,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadData() async {
    try {
      var result =
          await customerService.customer(uid: uid.toString(), email: '');
      customer = result.data;
      log('cussss: ${uid}');

      log('cussss: ${customer.first.price}');
      log('cussss: ${customer.first.uid}');
    } catch (err) {
      log('Error: $err');
    }
  }

  Widget showMoney() {
    return FutureBuilder(
        future: loadDataMethod, // 3.1 object ของ async method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.only(left: 20, right: 30, bottom: 20),
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                height: 158.0,
                width: 400.0,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 247, 142, 30),
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 4.0, // soften the shadow
                      spreadRadius: 1.0, //extend the shadow
                      offset: Offset(
                        0.0, // Move to right 5  horizontally
                        5.0, // Move to bottom 5 Vertically
                      ),
                    ),
                  ],
                ),
                    child: Stack(
                      children: [
                         Padding(
                          padding: EdgeInsets.only(top:MediaQuery.of(context).size.height * 0.03),
                          child: Icon(
                            FontAwesomeIcons.bahtSign,
                            size: 100,
                            color: Color.fromARGB(227, 255, 255, 255),
                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.only(left:  MediaQuery.of(context).size.height * 0.12,top:50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("ยอดเงินคงเหลือ",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w900, color: Color.fromARGB(255, 255, 255, 255),),
                              ),
                              Text(
                                customer.first.price.toString()+" บาท",
                                style: const TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.w900, color: Color.fromARGB(255, 255, 255, 255),),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     const Padding(
                  //       padding:
                  //           EdgeInsets.only(left: 30, right: 15, bottom: 15),
                  //       child: Text(
                  //         "ยอดเงินคงเหลือ",
                  //         style: TextStyle(
                  //             fontSize: 16, fontWeight: FontWeight.bold),
                  //       ),
                  //     ),
                  //     Row(
                  //       children: [
                  //         const Padding(
                  //           padding: EdgeInsets.only(left: 30, right: 5),
                  //           child: Icon(
                  //             FontAwesomeIcons.bahtSign,
                  //             size: 35,
                  //           ),
                  //         ),

                  //       ],
                  //     ),
                  //   ],
                  // ),
                  ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

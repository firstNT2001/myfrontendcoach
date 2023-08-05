import 'dart:developer';

import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../model/response/md_historyWallet_get.dart';
import '../../../../service/provider/appdata.dart';
import '../../../../service/wallet.dart';

class WidgetHistory extends StatefulWidget {
  WidgetHistory({super.key, required this.uid});
  late int uid;

  @override
  State<WidgetHistory> createState() => _WidgetHistoryState();
}

class _WidgetHistoryState extends State<WidgetHistory> {
  late List<Historywallet> history;
  late WalletService walletServiceService;
  late Future<void> loadDataMethod;
  @override
  void initState() {
    super.initState();
    walletServiceService =
        WalletService(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return showHistory();
  }

  Future<void> loadData() async {
    try {
      var datahistory = await walletServiceService.showHistorywall(uid: "1");
      history = datahistory.data;
      log(history.first.money.toString());
    } catch (err) {
      log('Error: $err');
    }
  }

  Widget showHistory() {
    return FutureBuilder(
        future: loadDataMethod, // 3.1 object ของ async method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  boxShadow: const [
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
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.48,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          log('llll'+history[index].date);
                          String day = history[index].date.substring(0, 2);

                          String month = history[index].date.substring(2, 4);
                          String year = history[index].date.substring(4);

                          DateTime dateTime =
                              DateTime.parse("$year-$month-$day");
                          thaiDate(dateTime.toString());
                          log(thaiDate(dateTime.toString()));
                          //DateTime time =  DateFormat("ddMMyyyy").parse(history[index].date);
                          final listhis = history[index];
                          return Card(
                            child: ListTile(
                              leading: Icon(FontAwesomeIcons.clockRotateLeft),
                              title: Text(thaiDate(dateTime.toString())),
                              subtitle: Text(
                                "+ ${listhis.amount} บาท",
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

String thaiDate(String datetime) {
  var formatter = DateFormat.yMMMd();
  DateTime dt = DateTime.parse(datetime).toLocal();
  var dateInBuddhistCalendarFormat = formatter.formatInBuddhistCalendarThai(dt);
  return dateInBuddhistCalendarFormat;
}
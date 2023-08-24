import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/page/user/mycourse/mycourse.dart';
import 'package:frontendfluttercoach/service/provider/appdata.dart';
import 'package:frontendfluttercoach/service/review.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';

import '../../../model/request/insertReview.dart';
import '../../../model/response/md_Buying_get.dart';
import '../../../model/response/md_Result.dart';
import '../../../service/buy.dart';
import '../../../widget/PopUp/popUp.dart';
import '../../../widget/dialogs.dart';
import '../../../widget/textField/wg_textFieldLines.dart';
import '../../../widget/textField/wg_textField_int.dart';
import '../../../widget/textField/wg_tx_inputint.dart';

class ShowReviewweightPage extends StatefulWidget {
  ShowReviewweightPage({super.key, required this.newweightreview,required this.billID});
  late int newweightreview;
    late String billID;

  @override
  State<ShowReviewweightPage> createState() => _ShowReviewweightPageState();
}

class _ShowReviewweightPageState extends State<ShowReviewweightPage> {
  late ReviewService reviewService;
  late BuyCourseService buyCourseService;
  late ModelResult moduleResult;
  List<Buying> buys = [];
  late int uid;
  late int coID;
  double value = 0.0;
  late Future<void> loadDataMethod;
  int newweight = 0;
  int sumweight = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = context.read<AppData>().uid;
    coID = context.read<AppData>().idcourse;
    log("coID" + coID.toString());
    reviewService = context.read<AppData>().reviewService;
    buyCourseService =
        BuyCourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = loadData();
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
      ),
      body: SafeArea(
        child: ListView(
          children: [
            loadbuy()
          ],
        ),
      ),
    );
  }

  Widget loadbuy() {
    return FutureBuilder(
        future: loadDataMethod,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          } else {
            //newweight = buys.first.weight;
           // log("newweight" + newweight.toString());
            return Column(children: [
              Text(buys.first.weight.toString())
            ],);
            // Align(
            //   alignment: Alignment.center,
            //   child: Container(
            //       width: MediaQuery.of(context).size.width * 0.7,
            //       height: MediaQuery.of(context).size.height * 0.5,
            //       decoration: const BoxDecoration(
            //         boxShadow: [
            //           BoxShadow(
            //             color: Color.fromARGB(101, 83, 83, 83),
            //             blurRadius: 20.0,
            //             spreadRadius: 0.1,
            //           ),
            //         ],
            //       ),
            //       child: (newweight > 0)
            //           ? Column(
            //               children: [
            //                 Container(
            //                   color: Colors.white,
            //                   child: Column(children: [
            //                     SizedBox(
            //                         width:
            //                             MediaQuery.of(context).size.width * 0.4,
            //                         height: MediaQuery.of(context).size.height *
            //                             0.1,
            //                         child:
            //                             Image.asset("assets/images/happy.png")),
            //                   ]),
            //                 ),
            //                 Text("ขอแสดงความยินดี")
            //               ],
            //             )
            //           : (newweight < 0)
            //               ? Container(
            //                   color: Colors.white,
            //                   child: Column(children: [
            //                     SizedBox(
            //                         width:
            //                             MediaQuery.of(context).size.width * 0.4,
            //                         height: MediaQuery.of(context).size.height *
            //                             0.1,
            //                         child:
            //                             Image.asset("assets/images/cry.png")),
            //                     Text("พยายามเข้านะ")
            //                   ]),
            //                 )
            //               : Container()),
            // );
          }
        });
  }

  Future<void> loadData() async {
    try {
      var databuy = await buyCourseService.buying(
          uid: '', coID: '', cid: '', bid: widget.billID);
      buys = databuy.data;
     // log("B"+buys.first.weight.toString());

   
    } catch (err) {
      log('Error: $err');
    }
  }
}

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import '../../../../model/response/md_Review_get.dart';
import '../../../../service/provider/appdata.dart';
import '../../../../service/review.dart';

class WidgetShowScore extends StatefulWidget {
   WidgetShowScore({super.key, required this.couseID});
  late String couseID;
  @override
  State<WidgetShowScore> createState() => _WidgetShowScoreState();
}

class _WidgetShowScoreState extends State<WidgetShowScore> {
    late Future<void> loadDataMethod;
  List<ModelReview> reviews = [];
  late ReviewService reviewService;
  double calRating = 0.00;
  int sumscore = 0;
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reviewService =
        ReviewService(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = loadData();
  }
  @override
  Widget build(BuildContext context) {
    return loadScore();
  }
    Widget loadScore() {
    return FutureBuilder(
      future: loadDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            
            children: [
              Icon(FontAwesomeIcons.solidStar,color: Colors.yellow,size: 22,),

              Text(
                calRating.toStringAsFixed(1),
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.white),
              ),
              
              
              
             
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
    Future<void> loadData() async {
    try {
      log("A");
      var datareview =
          await reviewService.review(coID: widget.couseID.toString());
      reviews = datareview.data;
      log("B");
      if(reviews.isNotEmpty){
          final summ = reviews.map((e) => e.score as int).toList();
        calRating = summ.average;
      }else {
        calRating = 0.0;
        sumscore = 0;
      }
    } catch (err) {
      log('Error: $err');
    }
  }
}
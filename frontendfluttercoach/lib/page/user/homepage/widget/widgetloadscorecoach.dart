import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../model/response/scorcoach.dart';
import '../../../../service/provider/appdata.dart';
import '../../../../service/review.dart';

class loadScorecoach extends StatefulWidget {
  loadScorecoach({super.key, required this.cid});
  late String cid;
  @override
  State<loadScorecoach> createState() => _loadScorecoachState();
}

class _loadScorecoachState extends State<loadScorecoach> {
  late Future<void> loadDataMethod;
  late ReviewService reviewService;
  late Scorecoach scorecoach;
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
    return  loadScore();
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
                scorecoach.score.toStringAsFixed(1),
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
     
      var datascore = await reviewService.scorecoach(widget.cid.toString());
      scorecoach = datascore.data;
      log("Scorecoach= " + scorecoach.score.toString());
    } catch (err) {
      log('Error: $err');
    }
  }
}

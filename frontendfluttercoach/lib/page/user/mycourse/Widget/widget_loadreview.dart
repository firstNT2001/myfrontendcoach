import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_native/flutter_rating_native.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import '../../../../model/response/md_Review_get.dart';
import '../../../../service/provider/appdata.dart';
import '../../../../service/review.dart';

class WidgetloadeReview extends StatefulWidget {
  WidgetloadeReview({super.key, required this.couseID});
  late String couseID;

  @override
  State<WidgetloadeReview> createState() => _WidgetloadeReviewState();
}

class _WidgetloadeReviewState extends State<WidgetloadeReview> {
  @override
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

  Widget build(BuildContext context) {
    return loadReview();
  }

  Widget loadReview() {
    return FutureBuilder(
      future: loadDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "คะแนนจากผู้ซื้อ",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    calRating.toStringAsFixed(1),
                    style:
                        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  FlutterRating(
                    size: 20,
                    starCount: 5,
                    rating: calRating,
                    allowHalfRating: true,
                    color: Colors.amber,
                    borderColor: Colors.grey,
                    mainAxisAlignment: MainAxisAlignment.center,
                  )
                ],
              ),
              Column(children: reviews.map((review) =>   Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                child: Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(review.customer.image),
                            radius: 30,
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(review.customer.username,
                                  style: Theme.of(context).textTheme.bodyLarge),
                              FlutterRating(
                                size: 20,
                                starCount: 5,
                                rating: review.score.toDouble(),
                                allowHalfRating: true,
                                color: Colors.amber,
                                borderColor: Colors.grey,
                                mainAxisAlignment: MainAxisAlignment.start,
                              )
                            ],
                          ),
                          subtitle: Text(review.details,
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                      ),
              )
           ).toList(),)
             
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

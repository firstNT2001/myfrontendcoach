import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/service/provider/appdata.dart';
import 'package:frontendfluttercoach/service/review.dart';
import 'package:provider/provider.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late ReviewService reviewService;
  late int cid;
  late int courseId;
  final TextEditingController detail  = TextEditingController();
  late int score;
  final TextEditingController weight  = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cid = context.read<AppData>().cid;
    reviewService = ReviewService(Dio(), baseUrl: context.read<AppData>().baseurl);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/trophy.png")
          ],
        ),
      ),
    );
  }

}
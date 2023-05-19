import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:frontendfluttercoach/service/review.dart';
import 'package:provider/provider.dart';



import '../../model/response/course_get_res.dart';
import '../../model/response/md_Review_get.dart';
import '../../service/course.dart';
import '../../service/provider/appdata.dart';

class showCousePage extends StatefulWidget {
  const showCousePage({super.key});

  @override
  State<showCousePage> createState() => _showCousePageState();
}

class _showCousePageState extends State<showCousePage> {
  late CourseService courseService;
  late Future<void> loadDataMethod;
  late ReviewService reviewService;

  //List<ModelCourse> courses = [];
  int courseId = 0;
  late ModelCourse courses;
  List<ModelReview> reviews = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    courseId = context.read<AppData>().idcourse;
    courseService =
        CourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
    reviewService =
        ReviewService(Dio(), baseUrl: context.read<AppData>().baseurl);

    loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("show course"),
        ),
        body: ListView(
          children: <Widget>[
            Expanded(
              child: Column(
                children: [
                  Container(
                    child: Column(children: [loadCorse()]),
                  ),
                  
                   
                      SizedBox(
                        height: 320,width: 390,
                        child: loadReview())
                    
                  
                ],
              ),
            ),
          ],
        ));
  }

  Future<void> loadData() async {
    try {
      log(courseId.toString());
      var datas = await courseService.course(cid: '',coID: courseId.toString(),name: '');
      var datareview = await reviewService.getReviewByCoID(courseId.toString());
      courses = datas.response.data;
      reviews = datareview.data;
      log('couse: ${courses.name}');
      //log('review: ${reviews.length}');
    } catch (err) {
      log('Error: $err');
    }
  }

  Widget loadReview() {
    return FutureBuilder(
      future: loadDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              if (courses != null)
                Expanded(
                  child: ListView.builder(
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        final review = reviews[index];
                        return Card(
                          child: ListTile(
                            title: Text(review.uid.toString()),
                            subtitle: Text(review.details),
                          ),
                        );
                      }),
                )
              else
                Container(),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget loadCorse() {
    return FutureBuilder(
        future: loadDataMethod, // 3.1 object ของ async method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                SizedBox(
                    height: 35,
                    width: 390,
                    child: Text(
                      "Daily workout",
                      style: TextStyle(fontSize: 25),
                    )),
                Image.network(
                  courses.image,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Column(
                  children: [
                    SizedBox(
                        width: 200, height: 100, child: Text(courses.name)),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(courses.days.toString() + "วัน/คอร์ส"),
                        ),
                        Text("27 คลิป")
                      ],
                    ),
                    Row(
                      children: [
                        Text(courses.amount.toString() + "คน"),
                        Text(courses.price.toString() + "บาท"),
                      ],
                    ),
                    Text("รายละเอียดคอร์ส"),
                    Text(courses.details),
                  ],
                )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

}

// class showCousePage extends StatelessWidget {
//   final ModelCourse couse;
//   const showCousePage({
//     Key? key,
//     required this.couse,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(couse.name),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//              Image.network(
//               couse.image,
//               height: 200,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//             Card(
//               child: Expanded(child: Text(couse.name)),
//             ),
//             Card(
//               child: Expanded(child: Padding(
//                 padding: const EdgeInsets.all(18.0),
//                 child: Text(couse.details),
//               )),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

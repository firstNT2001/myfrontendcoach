import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/page/user/mycourse.Detaildart/showFood_Clip.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../model/response/md_Day_showmycourse.dart';
import '../../../service/course.dart';
import '../../../service/day.dart';
import '../../../service/provider/appdata.dart';

class ShowDayMycourse extends StatefulWidget {
  const ShowDayMycourse({super.key});

  @override
  State<ShowDayMycourse> createState() => _ShowDayMycourseState();
}

class _ShowDayMycourseState extends State<ShowDayMycourse> {
  late DayService dayService;
  // late HttpResponse<ModelCourse> courses;
  List<DayDetail> days = [];
  late Future<void> loadDataMethod;
  int coID = 0;
  String img = "";
  String namecourse = "";
  String namecoach = "";
  String detail = "";
  void initState() {
    // TODO: implement initState
    super.initState();
    coID = context.read<AppData>().idcourse;
    img = context.read<AppData>().img;
    namecourse = context.read<AppData>().namecourse;
    namecoach = context.read<AppData>().namecoach;
    detail = context.read<AppData>().detail;

    dayService = DayService(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          //loadCourse(),
          Expanded(child: loadDay())
        ],
      ),
    );
  }

  Future<void> loadData() async {
    try {
      var dataday =
          await dayService.day(did: '', coID: coID.toString(), sequence: '');
      days = dataday.data;
      log('couse: ${days.length}');
    } catch (err) {
      log('Error: $err');
    }
  }

  Widget loadCourse() {
    return FutureBuilder(
      future: loadDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 35,
                  width: 390,
                  child: Text(
                    "Daily workout",
                    style: TextStyle(fontSize: 25),
                  )),
              Image.network(
                img,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 25),
                child: Text(namecourse,
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 8),
                child: Text(namecoach,
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text("รายละเอียดคอร์ส",
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 17, bottom: 8, right: 8),
                child:
                    Text(detail, style: Theme.of(context).textTheme.bodyLarge),
              ),
            ],
          );
        }
      },
    );
  }

  Widget loadDay() {
    return FutureBuilder(
      future: loadDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView(
            children: [
              SizedBox(
                  height: 35,
                  width: 390,
                  child: Text(
                    "Daily workout",
                    style: TextStyle(fontSize: 25),
                  )),
              Image.network(
                img,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 25),
                child: Text(namecourse,
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 8),
                child: Text(namecoach,
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text("รายละเอียดคอร์ส",
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 17, bottom: 8, right: 8),
                child:
                    Text(detail, style: Theme.of(context).textTheme.bodyLarge),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: days.length,
                  itemBuilder: (context, index) {
                    final listday = days[index];
                    return Card(
                      child: ListTile(
                       title: Row(
                         children: [
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Text("วันที่", style: Theme.of(context).textTheme.bodyLarge),
                           ),
                           Padding(
                             padding: const EdgeInsets.only(top: 4),
                             child: Text(listday.sequence.toString(), style: Theme.of(context).textTheme.bodyLarge),
                           ),
                         ],
                       ),
                       trailing: ElevatedButton(onPressed: (){
                        log(" DID:= "+listday.did.toString());
                        context.read<AppData>().did = listday.did;
                        Get.to(() => const showFood());
                       }, child: Text("เริ่ม", style: Theme.of(context).textTheme.bodyLarge)),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }

  //   Widget loadcourse() {
  //   return FutureBuilder(
  //     future: loadDataMethod,
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState != ConnectionState.done) {
  //         return const Center(child: CircularProgressIndicator());
  //       } else {
  //         return ListView.builder(
  //           shrinkWrap: true,
  //           itemCount: days.length,
  //           itemBuilder: (context, index) {
  //         final listcours = days[index];

  //         return Card(
  //           color: Color.fromARGB(255, 235, 235, 235),
  //           child: Container(
  //             height: 210,
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.end,
  //               children: [
  //                 Image.network(listcours.image,
  //                     width: 400, height: 110, fit: BoxFit.fill),
  //                 ListTile(
  //                   title: Text(listcours.name),
  //                   subtitle: Text(listcours.coach.fullName),
  //                    trailing: ElevatedButton(
  //                       onPressed: () {
  //                         log(listcours.coId.toString());
  //                         context.read<AppData>().idcourse = listcours.coId;
  //                         log(" uid : ${customer.data.uid}");
  //                         log(" money : ${customer.data.price}");
  //                         context.read<AppData>().uid = customer.data.uid;
  //                         context.read<AppData>().money = customer.data.price;
  //                         Get.to(() => const showCousePage());
  //                       },
  //                       style: ElevatedButton.styleFrom(
  //                           primary:
  //                               Color.fromARGB(230, 18, 17, 17)),
  //                       child: const Text("ดูรายละเอียดเพิ่มเติม",style: TextStyle(color: Colors.white),)),
  //                   contentPadding: EdgeInsets.symmetric(
  //                       vertical: 0.0, horizontal: 8.0),
  //                 ),

  //               ],
  //             ),
  //           ),
  //         );
  //           },
  //         );
  //       }
  //     },
  //   );
  // }
}

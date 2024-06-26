import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/page/coach/usersBuyCourses/show_courseAll_user_page.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../../model/response/md_Buying_get.dart';
import '../../../service/buy.dart';
import '../../../service/provider/appdata.dart';
import '../../../widget/dialogs.dart';

class ShowUserByCoursePage extends StatefulWidget {
  const ShowUserByCoursePage({super.key});

  @override
  State<ShowUserByCoursePage> createState() => _ShowUserByCoursePageState();
}

class _ShowUserByCoursePageState extends State<ShowUserByCoursePage> {
  // Courses
  late Future<void> loadCourseDataMethod;
  late BuyCourseService _BuyingService;
  List<Buying> courses = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _BuyingService = context.read<AppData>().buyCourseService;
    loadCourseDataMethod = loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return scaffold(context);
  }

  Scaffold scaffold(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        //backgroundColor: Theme.of(context).colorScheme.primary,
        title: Center(
          child: Text(
            "ผู้ใช้ที่ซื้อคอร์ส",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
              child: showUser(),
            ),
          ),
        ],
      ),
    );
  }

  //LoadData
  Future<void> loadUserData() async {
    try {
      //Courses
      var datas = await _BuyingService.courseUsers(
          cid: context.read<AppData>().cid.toString());
      courses = datas.data;
      // for (var inder in courses) {
      //   log(inder.buying!.customer.image);
      // }
    } catch (err) {
      log('Error: $err');
    }
  }

  //Show Data
  Widget showUser() {
    return FutureBuilder(
      future: loadCourseDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: load(context));
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                child: InkWell(
                  onTap: () {
                    context.read<AppData>().nameCus = course.customer.fullName;
                    pushNewScreen(
                      context,
                      screen: ShowCourseUserPage(
                          uid: course.customer.uid.toString()),
                      withNavBar: true,
                    ).then((value) {
                      setState(() {
                        loadCourseDataMethod = loadUserData();
                      });
                    });
                  },
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          // ignore: unnecessary_null_comparison
                          if (course.customer.image != '-') ...{
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(course.customer.image),
                              radius: 35,
                            )
                          } else
                            const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://i.pinimg.com/564x/a8/0e/36/a80e3690318c08114011145fdcfa3ddb.jpg'),
                              radius: 35,
                            ),
                          const SizedBox(width: 20),
                          AutoSizeText(
                            course.customer.fullName,
                            maxLines: 5,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(endIndent: 20, indent: 20)
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/model/response/md_Buying_get.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../../service/buy.dart';
import '../../../service/provider/appdata.dart';
import '../course/course_edit_page.dart';

class ShowCourseUserPage extends StatefulWidget {
  const ShowCourseUserPage({super.key, required this.uid});
  final String uid;
  @override
  State<ShowCourseUserPage> createState() => _ShowCourseUserPageState();
}

class _ShowCourseUserPageState extends State<ShowCourseUserPage> {
  // Courses
  late Future<void> loadCourseDataMethod;
  late BuyCourseService _buyingService;
  List<Buying> courses = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _buyingService = context.read<AppData>().buyCourseService;
    loadCourseDataMethod = loadUserData();
    log(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          //backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          leading: IconButton(
            icon: const Icon(
              FontAwesomeIcons.chevronLeft,
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: SafeArea(
          child: ListView(
            children: [
              loadcourse(),
            ],
          ),
        ));
  }

  //LoadData
  Future<void> loadUserData() async {
    try {
      var datacouse = await _buyingService.buying(
          uid: widget.uid,
          cid: context.read<AppData>().cid.toString(),
          coID: '');
      courses = datacouse.data;
    } catch (err) {
      log('Error: $err');
    }
  }

  Widget loadcourse() {
    return FutureBuilder(
      future: loadCourseDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final listcours = courses[index];
              return Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: InkWell(
                    onTap: () {
                        Get.to(() => CourseEditPage(
                          coID: courses[index].course.coId.toString(),
                        ));
                    },
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topCenter,
                            child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xff7c94b6),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            listcours.course.image),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                )),
                            //color: Colors.white,
                          ),
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            alignment: Alignment.bottomCenter,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                                  // const Color.fromARGB(255, 0, 0, 0).withAlpha(0),
                                  // const Color.fromARGB(49, 0, 0, 0),
                                  // const Color.fromARGB(127, 0, 0, 0)
                                  const Color.fromARGB(255, 255, 255, 255)
                                      .withAlpha(0),
                                  const Color.fromARGB(39, 255, 255, 255),
                                  const Color.fromARGB(121, 255, 255, 255)
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(listcours.course.name,
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 8),
                                      child: Icon(
                                        FontAwesomeIcons.solidUser,
                                        size: 16.0,
                                      ),
                                    ),
                                    Text(listcours.customer.fullName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/model/request/day_dayID_put.dart';
import 'package:frontendfluttercoach/model/response/md_Result.dart';
import 'package:frontendfluttercoach/model/response/md_RowsAffected.dart';
import 'package:frontendfluttercoach/model/response/md_days.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../../service/days.dart';
import '../../../service/provider/appdata.dart';
import '../course/course_edit_page.dart';
import '../home_foodAndClip.dart';

class DaysCoursePage extends StatefulWidget {
  DaysCoursePage({super.key, required this.coID});
  late String coID;
  @override
  State<DaysCoursePage> createState() => _DaysCoursePageState();
}

class _DaysCoursePageState extends State<DaysCoursePage> {
  //Service
  //Days
  late DaysService _daysService;
  late Future<void> loadDaysDataMethod;
  late ModelResult modelResult;
  List<ModelDay> days = [];

  //
  bool onVisibles = true;
  bool offVisibles = false;

  //title
  String title = 'Days';

  int numberOfDays = 0;
  @override
  void initState() {
    super.initState();
    context.read<AppData>().coID = int.parse(widget.coID);

    _daysService = context.read<AppData>().daysService;
    loadDaysDataMethod = loadDaysDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.chevronLeft,
            color: Colors.white,
          ),
          onPressed: () {
            Get.to(() => CourseEditPage(
                  coID: widget.coID,
                ));
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.penToSquare,
            ),
            onPressed: () {
              setState(() {
                onVisibles = !onVisibles;
                offVisibles = !offVisibles;
              });
              if (offVisibles == true) {
                setState(() {
                  title = 'Edit days';
                });
              } else {
                setState(() {
                  title = 'Days';
                  loadDaysDataMethod = loadDaysDataAsync();
                });
              }
            },
          )
        ],
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(title),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: loadDaysDataMethod,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  children: [
                    //edit Day
                    if (offVisibles == true)
                      Expanded(
                        child: Visibility(
                          visible: offVisibles,
                          child: ReorderableListView.builder(
                            shrinkWrap: false,
                            itemCount: days.length,
                            itemBuilder: (context, index) {
                              final listday = days[index];
                              return Padding(
                                key: ValueKey(listday),
                                padding: const EdgeInsets.only(
                                    top: 8, left: 18, right: 18),
                                child: Card(
                                  key: ValueKey(listday),
                                  child: ListTile(
                                    key: ValueKey(listday),
                                    title: Text(listday.sequence.toString()),
                                    subtitle: Text(listday.did.toString()),
                                    trailing: IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          FontAwesomeIcons.trash,
                                        )),
                                  ),
                                ),
                              );
                            },
                            onReorder: ((oldIndex, newIndex) =>
                                updateDays(oldIndex, newIndex)),
                          ),
                        ),
                      ),
                    //Not Edit Day
                    if (onVisibles == true)
                      Expanded(
                        child: Visibility(
                          visible: onVisibles,
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 8, left: 18, right: 18),
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: days.length,
                                itemBuilder: (context, index) {
                                  final listdays = days[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Card(
                                      child: ListTile(
                                        title:
                                            Text(listdays.sequence.toString()),
                                        subtitle: Text(listdays.did.toString()),
                                        trailing: Icon(Icons.more_vert),
                                        onTap: () {
                                          Get.to(() => HomeFoodAndClipPage(
                                                did: listdays.did.toString(),
                                                sequence: listdays.sequence
                                                    .toString(),
                                              ));
                                        },
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  Future<void> loadDaysDataAsync() async {
    try {
      var res =
          await _daysService.days(did: '', coID: widget.coID, sequence: '');
      days = res.data;
      log("did: ${days.first.foods.length.toString()}");
      // name.text = foods.name;
    } catch (err) {
      log('Error: $err');
    }
  }

  void updateDays(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex--;
      }

      final listdays = days.removeAt(oldIndex);

      days.insert(newIndex, listdays);
      log("วันใหม่ ${newIndex.toString()}");

      updateDay(days);
    });
  }

  Future<void> updateDay(List<ModelDay> days) async {
    for (int i = 0; i < days.length; i++) {
      //log(days[i].sequence.toString());
      DayDayIdPut request = DayDayIdPut(sequence: i + 1);

      var response =
          await _daysService.updateDayByDayID(days[i].did.toString(), request);
      modelResult = response.data;
      log("${days[i].did.toString()} : ${jsonEncode(request)}");
    }
  }
}

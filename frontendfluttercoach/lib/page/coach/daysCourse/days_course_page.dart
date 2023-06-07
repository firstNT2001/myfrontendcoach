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

    _daysService = context.read<AppData>().daysService;
    loadDaysDataMethod = loadDaysDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.penToSquare,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                onVisibles = !onVisibles;
                offVisibles = !offVisibles;
                if (offVisibles == true)
                  title = 'Edit days';
                else
                  title = 'Days';
              });
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
                                    onTap: () {
                                      Get.to(() => HomeFoodAndClipPage(
                                            did: listday.did.toString(),
                                            sequence:
                                                listday.sequence.toString(),
                                          ));
                                    },
                                  ),
                                ),
                              );
                            },
                            onReorder: ((oldIndex, newIndex) =>
                                updateDays(oldIndex, newIndex)),

                            // for (final listday in days)
                            //   ListTile(
                            //       key: ValueKey(listday),
                            //       title: Text(listday.sequence.toString()),
                            //       onTap: () {},)
                          ),
                        ),
                      ),
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
                    if (offVisibles == true)
                      Visibility(
                          visible: offVisibles,
                          child: SizedBox(
                            width: double.infinity,
                            height: 100,
                            child: ElevatedButton(
                              child: Text('yes'),
                              onPressed: () {},
                            ),
                          )),
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
    setState(() async {
      if (oldIndex < newIndex) {
        newIndex--;
      }

      final listdays = days.removeAt(oldIndex);

      days.insert(newIndex, listdays);
      log("วันใหม่ ${newIndex.toString()}");

      updateDay(days);
    });
  }

  Future<void> updateDay(days) async {
    for (int i = 0; i < days.length; i++) {
      //log(days[i].sequence.toString());
      DayDayIdPut request = DayDayIdPut(sequence: i + 1);

       var response = await _daysService.updateDayByDayID(days[i].did.toString(),request);
      // modelResult = response.data;
      log("${days[i].did.toString()} : ${jsonEncode(request)}");
    }
    setState(() {
      onVisibles = !onVisibles;
      offVisibles = !offVisibles;
      if (offVisibles == true)
        title = 'Edit days';
      else
        title = 'Days';
    });
  }
}

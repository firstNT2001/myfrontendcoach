import 'dart:developer';

import 'package:flutter/material.dart';
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
  List<ModelDay> days = [];

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
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text("Day"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: loadDaysDataMethod,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ReorderableListView.builder(
                  shrinkWrap: false,
                  itemCount: days.length,
                  itemBuilder: (context, index) {
                    final listday = days[index];

                    return Padding(
                      key: ValueKey(listday),
                      padding: const EdgeInsets.only(top:8,left: 18,right:18),
                      child: Card(
                        key: ValueKey(listday),
                        child: ListTile(
                          key: ValueKey(listday),
                          title: Text(listday.sequence.toString()),
                          onTap: () {
                            Get.to(() =>  HomeFoodAndClipPage(did: listday.did.toString(), sequence: listday.sequence.toString(),));
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
      final listdays = days.removeAt(oldIndex);

      days.insert(newIndex, listdays);
    });
  }
}

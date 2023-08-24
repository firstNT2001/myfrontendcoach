import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../../../model/response/md_process.dart';
import '../../../../service/progessbar.dart';
import '../../../../service/provider/appdata.dart';

class WidgetProgess extends StatefulWidget {
   WidgetProgess({super.key,required this.coID});
late String coID;
  @override
  State<WidgetProgess> createState() => _WidgetProgessState();
}

class _WidgetProgessState extends State<WidgetProgess> {
   late ProgessbarService progessService;
  late Modelprogessbar progess;
   
       double percen = 0.00;
        double percenText = 0.00;
late Future<void> loadDataMethod;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
        progessService =
        ProgessbarService(Dio(), baseUrl: context.read<AppData>().baseurl);
          loadDataMethod = loadData();
  }
  @override
  Widget build(BuildContext context) {
    return  loadprogess();
  }
   Future<void> loadData() async {
    try {
     

        log("i${widget.coID}");
        var datas = await progessService.processbar(
            coID: widget.coID);
        progess = datas.data;
        percen=(progess.percent)/100;
        percenText=(progess.percent).toPrecision(2);
        //percenText=(progess.percent).toPrecision(1);
       // listpercent.add(percen);
        //listpercentText.add(percenText);
        log("percent${percen.toString()}");
       // log("percentTEXT${percenText.toString()}");
      
    } catch (err) {
      log('Error: $err');
    }
  }
    Widget loadprogess() {
    return FutureBuilder(
      future: loadDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return   Padding(
                                    padding:
                                        EdgeInsets.only(bottom: 4.0, top: 4.0),
                                    child: FittedBox(
                                      child: LinearPercentIndicator(
                                        width: MediaQuery.of(context).size.width *
                                            0.65,
                                        fillColor:
                                            Color.fromARGB(0, 255, 255, 255),
                                        lineHeight: 10.0,
                                        percent: percen,
                                        trailing: Text(
                                          percenText.toString()+"%",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white),
                                        ),
                                        barRadius: Radius.circular(7),
                                        backgroundColor: Colors.grey,
                                        progressColor:
                                            Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  );
        }
      },
    );
  }
  
}
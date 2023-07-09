import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../model/response/md_request.dart';
import '../../../service/provider/appdata.dart';
import '../../../service/request.dart';

class AlertPage extends StatefulWidget {
  const AlertPage({super.key});

  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  int uid = 0;
  late RequestService requestService;
  late Future<void> loadDataMethod;
  List<ModelRequest> requests=[];
  late String txtStatus;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = context.read<AppData>().uid;
    requestService = RequestService(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = loadData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
  Widget loadRequrst(){
    return FutureBuilder(
        future: loadDataMethod, // 3.1 object ของ async method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder( 
              itemCount: requests.length,
              itemBuilder: (context, index){
                 final request = requests[index];
                 return Card(
              child: ListTile(
                leading: Icon(FontAwesomeIcons.solidBell),
                //title: request.,
              ),
            );

              });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
  
  Future<void> loadData() async {
    try {
      var datarequest = await requestService.request(rqID: '', uid: uid.toString(), cid:'');
      requests = datarequest.data;
      for(int i=0;i<requests.length-1;i++){
        if(requests[i].status == "1"){
          txtStatus ="ดำเนินการเสร็จสิ้น";
      }else{
        txtStatus ="กำลงดำเนินการดำเนินการ";
      }
      }
      
     
    } catch (err) {
      log('Error: $err');
    }
  }
}
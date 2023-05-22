import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../../model/request/listClip_coachID_post.dart';
import '../../../model/response/md_Result.dart';
import '../../../service/listClip.dart';
import '../../../service/provider/appdata.dart';
import '../../../widget/wg_textField.dart';
import 'clip_page.dart';

class ClipNewCoachPage extends StatefulWidget {
  const ClipNewCoachPage({super.key});

  @override
  State<ClipNewCoachPage> createState() => _ClipNewCoachPageState();
}

class _ClipNewCoachPageState extends State<ClipNewCoachPage> {

  late ListClipServices _listClipServices;
  late ModelResult modelResult;
  String cid = '';
  //Controller
  final name = TextEditingController();
  final amountPerSet = TextEditingController();
  final details = TextEditingController();
  @override
  void initState() {
    super.initState();
    cid = context.read<AppData>().cid.toString();
    name.text = 'ท่าเลกลันจ์';
    amountPerSet.text = '5เซ็ท เซ็ทละ20ครั้ง';
    details.text =
        'ท่านี้ช่วยบริหารต้นขาด้านหน้า ก้น และกล้ามเนื้อแฮมสตริง ทำให้ขาและกันกระชับ กล้ามเนื้อขาเข็งแรง';
    _listClipServices= context.read<AppData>().listClipServices;
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          WidgetTextFieldString(
            controller: name,
            labelText: 'ชื่อ',
          ),
          WidgetTextFieldString(
            controller: amountPerSet,
            labelText: 'จำนวนเซ็ท',
          ),
          WidgetTextFieldString(
            controller: details,
            labelText: 'รายละเอียดท่า',
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () async {
                  ListClipCoachIdPost listClipCoachIdPost = ListClipCoachIdPost(
                      name: name.text,
                      amountPerSet: amountPerSet.text,
                      video: '',
                      details: details.text);
                  var insertClip = await _listClipServices.insertListClipByCoachID(cid, listClipCoachIdPost);
                  modelResult = insertClip.data;
                  log(jsonEncode(modelResult.code));
                  if(modelResult.result == '1'){
                    Get.to(() => const ClipCoachPage());
                  }
                },
                child: const Text("บันทึก")),
          )
        ],
      ),
    );
  }
}

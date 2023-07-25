import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../model/response/md_request.dart';
import '../../service/provider/appdata.dart';
import '../../service/request.dart';
import '../coach/course/FoodAndClip/clipCourse/editClip/clip_edit_select.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  String cid = "";

  //Request
  List<Request> requests = [];
  late Future<void> loadRequestDataMethod;
  late RequestService _RequestService;

  @override
  void initState() {
    // TODO: implement initState
    cid = context.read<AppData>().cid.toString(); //ID Course

    //Request
    _RequestService = context.read<AppData>().requestService;
    loadRequestDataMethod = loadRequestData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text("Notification"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: showRequest(),
            ),
          ),
        ],
      )),
    );
  }

  Widget showRequest() {
    return FutureBuilder(
        future: loadRequestDataMethod, // 3.1 object ของ async method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ignore: unnecessary_null_comparison
                if (requests != null)
                  Expanded(
                    child: ListView.builder(
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        var request = requests[index];
                        return SizedBox(
                          //height: MediaQuery.of(context).size.height,
                          child: InkWell(
                            onTap: () {
                              dialogShow(context, request);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 5),
                                  child: Row(
                                    children: [
                                      if (request.customer.image != '-') ...{
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              request.customer.image),
                                          radius: 35,
                                        )
                                      } else
                                        const CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              'https://i.pinimg.com/564x/a8/0e/36/a80e3690318c08114011145fdcfa3ddb.jpg'),
                                          radius: 35,
                                        ),
                                      const SizedBox(width: 20),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AutoSizeText(
                                            request.customer.fullName,
                                            maxLines: 5,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          AutoSizeText(
                                            request.clip.listClip.name,
                                            maxLines: 5,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Divider(endIndent: 20, indent: 20)
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else
                  Container(),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Future<void> loadRequestData() async {
    try {
      var datas = await _RequestService.request(rqID: '', uid: '', cid: cid);
      requests = datas.data;
      log(requests.length.toString());
    } catch (err) {
      log('Error: $err');
    }
  }

  void dialogShow(BuildContext context, Request request) {
    //target widget
    SmartDialog.show(builder: (_) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.62,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  if (request.customer.image != '-') ...{
                    CircleAvatar(
                      backgroundImage: NetworkImage(request.customer.image),
                      radius: 50,
                    )
                  } else
                    const CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://i.pinimg.com/564x/a8/0e/36/a80e3690318c08114011145fdcfa3ddb.jpg'),
                      radius: 50,
                    ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    request.customer.fullName,
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                ],
              ),
            ),
            const Divider(
              endIndent: 20,
              indent: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 8.0),
              child: Text('ต้องการเปลี่ยนท่า', style: Theme.of(context).textTheme.titleMedium,),
            ),
            Padding(
               padding: const EdgeInsets.only(left: 45.0, bottom: 8.0),
              child: AutoSizeText(
                '  ${request.clip.listClip.name}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
             Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 8.0),
              child: Text('รายละเอียด', style: Theme.of(context).textTheme.titleMedium,),
            ),
            Padding(
               padding: const EdgeInsets.only(left: 45.0,right: 13, bottom: 8.0),
              child: AutoSizeText(
                '  ${request.details}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                //mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                      onPressed: () {
                        SmartDialog.dismiss();
                      },
                      child: const Text("ยกเลิก")),
                  FilledButton(
                      onPressed: () {
                        context.read<AppData>().rqID = request.rpId.toString();
                        Get.to(() => ClipEditSelectPage(cpID: request.clipId.toString(), did: request.clip.dayOfCouseId.toString(), isVisible: false, sequence: '', status: 1,));
                      },
                      child: const Text("ตกลง"))
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

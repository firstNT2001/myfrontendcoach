import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../../../../../../model/request/clip_clipID_put.dart';
import '../../../../../../model/response/clip_get_res.dart';
import '../../../../../../model/response/md_ClipList_get.dart';
import '../../../../../../model/response/md_Result.dart';
import '../../../../../../model/response/md_days.dart';
import '../../../../../../service/clip.dart';
import '../../../../../../service/days.dart';
import '../../../../../../service/listClip.dart';
import '../../../../../../service/provider/appdata.dart';
import '../../../../../../service/request.dart';
import '../../../../../../widget/image_video.dart';
import '../../../../../../widget/showCilp.dart';
import '../../../../../Request/request_page.dart';
import '../../course_food_clip.dart';

class ClipEditSelectPage extends StatefulWidget {
  const ClipEditSelectPage(
      {super.key,
      required this.cpID,
      required this.did,
      required this.sequence,
      required this.status,
      required this.isVisible});
  final String cpID;
  final String did;
  final String sequence;
  final int status;
  final bool isVisible;
  @override
  State<ClipEditSelectPage> createState() => _ClipEditSelectPageState();
}

class _ClipEditSelectPageState extends State<ClipEditSelectPage> {
  // ClipService
  late Future<void> loadListClipDataMethod;
  late ListClipServices _listclipService;
  List<ListClip> clips = [];
  List<ModelClip> modelClip = [];
  late ModelResult modelResult;

  late ClipServices _clipService;
  late DaysService _dayService;
  List<ModelDay> modelDay = [];
  //Request
  // ignore: non_constant_identifier_names
  late RequestService _RequestService;

  String nameClip = "";
  bool _enabled = true;

  @override
  void initState() {
    super.initState();
    _clipService = context.read<AppData>().clipServices;

    _listclipService = context.read<AppData>().listClipServices;
    loadListClipDataMethod = loadListClipData();

    _dayService = context.read<AppData>().daysService;

    //Request
    _RequestService = context.read<AppData>().requestService;

    loadDayData();
    loadClipData();
    Future.delayed(Duration(seconds: context.read<AppData>().duration), () {
      setState(() {
        _enabled = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return (_enabled == true)
        ? Skeletonizer(
            enabled: true,
            child: scaffold(context),
          )
        : scaffold(context);
  }

  Scaffold scaffold(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.chevronLeft,
            //color: Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text('เลือกท่าออกกำลังกาย'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: showClip(),
          ),
        ],
      ),
    );
  }

  //LoadData
  Future<void> loadListClipData() async {
    try {
      // log(widget.did);
      var datas = await _listclipService.listClips(
          icpID: '', cid: context.read<AppData>().cid.toString(), name: '');
      clips = datas.data;
      // log(foods.length.toString());
    } catch (err) {
      log('Error: $err');
    }
  } 
   //LoadData
  Future<void> loadDayData() async {
    try {
      // log(widget.did);
      var datas = await _dayService.days(did: widget.did.toString(), coID: '', sequence: '');
      modelDay = datas.data;
      // log(foods.length.toString());
    } catch (err) {
      log('Error: $err');
    }
  }

   //LoadData
  Future<void> loadClipData() async {
    try {
      // log(widget.did);
      var datas = await _clipService.clips(cpID: widget.cpID, icpID: '', did: '');
      modelClip = datas.data;
      // log(foods.length.toString());
    } catch (err) {
      log('Error: $err');
    }
  }

  //LoadData
  Future<void> loadDayData() async {
    try {
      // log(widget.did);
      var datas = await _dayService.days(
          did: widget.did.toString(), coID: '', sequence: '');
      modelDay = datas.data;
      // log(foods.length.toString());
    } catch (err) {
      log('Error: $err');
    }
  }

  //LoadData
  Future<void> loadClipData() async {
    try {
      // log(widget.did);
      var datas =
          await _clipService.clips(cpID: widget.cpID, icpID: '', did: '');
      modelClip = datas.data;
      // log(foods.length.toString());
    } catch (err) {
      log('Error: $err');
    }
  }

  Widget showClip() {
    return FutureBuilder(
      future: loadListClipDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container();
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: clips.length,
            itemBuilder: (context, index) {
              final listClip = clips[index];
              return Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: InkWell(
                      onTap: () {
                        dialog(context, listClip.icpId, listClip.name,
                            listClip.amountPerSet, listClip.video);
                      },
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (listClip.video != '') ...{
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 5, bottom: 5),
                              child: AspectRatio(
                                  aspectRatio: 16 / 16,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(26),
                                        color: Colors.pink),
                                    child: VideoItem(
                                      video: listClip.video,
                                    ),
                                  )),
                            )
                          } else
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 5, bottom: 5),
                              child: AspectRatio(
                                  aspectRatio: 16 / 16,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 207, 208, 209),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  )),
                            ),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: AutoSizeText(
                                  listClip.name,
                                  maxLines: 5,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Text(
                              //   "Calories : ${listClip.calories}",
                              //   style: Theme.of(context).textTheme.titleMedium,
                              // )
                            ],
                          ),
                          //const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    indent: 20,
                    endIndent: 20,
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }

  void dialog(
      BuildContext context, int icpID, String name, String set, String video) {
    SmartDialog.show(
      alignment: Alignment.bottomCenter,
      builder: (_) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            color: Colors.white,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(name,
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                  if (video != '') ...{
                    WidgetShowCilp(urlVideo: video),
                  } else ...{
                    Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(26),
                            color: Theme.of(context).colorScheme.primary)),
                    const SizedBox(
                      height: 8,
                    ),
                  },
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 10),
                    child: Text("จำนวนเซต",
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: AutoSizeText(
                        "   $set",
                        maxLines: 8,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                  visible: widget.isVisible,
                  child: buttonEditClip(icpID, name, context)),
              if (widget.isVisible == false) ...{
                buttonRequest(icpID, name, context)
              }
            ],
          ),
        );
      },
    );
  }

  Row buttonEditClip(int icpID, String name, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: ElevatedButton(
              onPressed: () async {
                log(widget.cpID);
                ClipClipIdPut request = ClipClipIdPut(
                  listClipId: icpID,
                  dayOfCouseId: int.parse(widget.did),
                );
                log(jsonEncode(request));
                var response =
                    await _clipService.updateClipByClipID(widget.cpID, request);
                modelResult = response.data;
                log(modelResult.result);

                if (modelResult.result == '1') {
                  Get.to(() => HomeFoodAndClipPage(
                        did: widget.did,
                        sequence: widget.sequence,
                        isVisible: widget.isVisible,
                      ));
                } else {
                  // ignore: use_build_context_synchronously
                  CherryToast.warning(
                    title: Text('มีเมนู $name ในวันนี้แล้ว'),
                    displayTitle: false,
                    description: Text('มีเมนู $name ในวันนี้แล้ว'),
                    toastPosition: Position.bottom,
                    animationDuration: const Duration(milliseconds: 1000),
                    autoDismiss: true,
                  ).show(context);
                }
              },
              child: const Text("บันทึก")),
        ),
      ],
    );
  }

  Row buttonRequest(int icpID, String name, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: ElevatedButton(
              onPressed: () async {
                log(widget.cpID);
                ClipClipIdPut request = ClipClipIdPut(
                  listClipId: icpID,
                  dayOfCouseId: int.parse(widget.did),
                );
                log(jsonEncode(request));
                var response =
                    await _clipService.updateClipByClipID(widget.cpID, request);
                modelResult = response.data;
                log(modelResult.result);

                if (modelResult.result == '0') {
                  // ignore: use_build_context_synchronously
                  CherryToast.warning(
                    title: Text('มีเมนู $name ในวันนี้แล้ว'),
                    displayTitle: false,
                    description: Text('มีเมนู $name ในวันนี้แล้ว'),
                    toastPosition: Position.bottom,
                    animationDuration: const Duration(milliseconds: 1000),
                    autoDismiss: true,
                  ).show(context);
                } else {
                  var response =
                      // ignore: use_build_context_synchronously
                      await _RequestService.updateRequestStatus(
                          context.read<AppData>().rqID);
                  modelResult = response.data;
                  if (modelResult.result == '0') {
                  } else {
                    types.User _user = types.User(
                        id: context.read<AppData>().cid.toString(),
                        firstName: "โค้ช ${context.read<AppData>().nameCoach}");
                    //textTeam
                    final message = types.TextMessage(
                      author: _user,
                      id: const Uuid().v4(),
                      text:
                          'โค้ชได้เปลี่ยนท่าเรียบร้อยแล้ว\nชื่อท่า:${modelClip.first.listClip.name}\nเปลี่ยนเป็น: $name',
                      createdAt: DateTime.now().millisecondsSinceEpoch,
                    );
                    FirebaseFirestore.instance
                        .collection(modelDay.first.courseId.toString())
                        .add(message.toJson());
                  }
                  Get.to(() => const RequestPage());
                }
              },
              child: const Text("บันทึก")),
        ),
      ],
    );
  }
}

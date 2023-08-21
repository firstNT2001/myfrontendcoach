import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/page/coach/FoodAndClip/clipCoach/clip_edit_page.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:in_app_notification/in_app_notification.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../model/response/md_ClipList_get.dart';
import '../../model/response/md_Result.dart';
import '../../service/listClip.dart';
import '../../service/provider/appdata.dart';
import '../../widget/dialogs.dart';
import '../../widget/image_video.dart';
import '../../widget/notificationBody.dart';

class SearchClipCoachPage extends StatefulWidget {
  const SearchClipCoachPage({super.key});

  @override
  State<SearchClipCoachPage> createState() => _SearchClipCoachPageState();
}

class _SearchClipCoachPageState extends State<SearchClipCoachPage> {
  //Service ListClip
  late ListClipServices _listClipService;
  late Future<void> loadClipDataMethod;
  late List<ListClip> clips = [];
  late ModelResult modelResult;

  TextEditingController searchName = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listClipService = context.read<AppData>().listClipServices;
    loadClipDataMethod = loadClipData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
            child: Column(
          children: [
            searchBar(context),
            const SizedBox(height: 20),
            Expanded(
              child: showClips(),
            ),
          ],
        )),
      ),
    );
  }

  //SearchBar
  Padding searchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.chevronLeft,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                color: const Color.fromRGBO(244, 243, 243, 1),
                borderRadius: BorderRadius.circular(15)),
            child: TextField(
              controller: searchName,
              autofocus: true,
              style: const TextStyle(color: Colors.black),
              onChanged: (value) {
                setState(() {
                  //isVisibles = true;
                  _listClipService
                      .listClips(
                          icpID: '',
                          cid: context.read<AppData>().cid.toString(),
                          name: searchName.text)
                      .then((fooddata) {
                    var datafoods = fooddata.data;
                    clips = datafoods;
                    if (clips.isNotEmpty) {
                      setState(() {});
                      log(clips.length.toString());
                    }
                  });
                });
              },
              onSubmitted: (value) {},
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  suffixIcon: Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: Colors.black,
                  ),
                  hintText: "ค้นหา...",
                  hintStyle: TextStyle(color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }

  //Dialog Delete
  void dialogDeleteClip(BuildContext context, String icpID) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'ต้องการลบคลิปหรือไม',
      confirmBtnText: 'ตกลง',
      cancelBtnText: 'ยกเลิก',
      confirmBtnColor: Theme.of(context).colorScheme.primary,
      onConfirmBtnTap: () async {
        var response = await _listClipService.deleteListClip(icpID);
        modelResult = response.data;
        log(modelResult.result);

        Navigator.of(context, rootNavigator: true).pop();
        // ignore: use_build_context_synchronously
        InAppNotification.show(
          child: NotificationBody(
            count: 1,
            message: 'ลบคลิปท่าออกกำลังกายเรียบร้อยแล้ว',
          ),
          context: context,
          onTap: () => print('Notification tapped!'),
          duration: const Duration(milliseconds: 1500),
        );
        setState(() {
          loadClipDataMethod = loadClipData();
        });
      },
    );
  }

  //LoadData
  Future<void> loadClipData() async {
    try {
      // log(widget.did);
      var datas = await _listClipService.listClips(
          icpID: '',
          cid: context.read<AppData>().cid.toString(),
          name: searchName.text);
      clips = datas.data;
      // log(foods.length.toString());
    } catch (err) {
      log('Error: $err');
    }
  }

  Widget showClips() {
    return FutureBuilder(
      future: loadClipDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: load(context));
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: clips.length,
            itemBuilder: (context, index) {
              final listClips = clips[index];
              return Slidable(
                endActionPane:
                    ActionPane(motion: const StretchMotion(), children: [
                  SlidableAction(
                    onPressed: (contexts) {
                      dialogDeleteClip(context, listClips.icpId.toString());
                      // Navigator.pop(context);
                    },
                    backgroundColor: Theme.of(context).colorScheme.error,
                    icon: Icons.delete,
                    label: 'Delete',
                  )
                ]),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: InkWell(
                        onTap: () {
                          Get.to(() =>
                                  ClipEditCoachPage(icpId: listClips.icpId))
                              ?.then((value) {
                            Navigator.pop(context);
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (listClips.video != '') ...{
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, top: 5, bottom: 5),
                                child: AspectRatio(
                                    aspectRatio: 16 / 16,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(26),
                                      ),
                                      child: VideoItem(
                                        video: listClips.video,
                                      ),
                                    )),
                              )
                            } else
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, top: 5, bottom: 5),
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Text(
                                    listClips.name,
                                    maxLines: 5,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Text(
                                    'จำนวนเซต ${listClips.amountPerSet}',
                                    maxLines: 5,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black38),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Divider(
                        endIndent: 15,
                        indent: 15,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}

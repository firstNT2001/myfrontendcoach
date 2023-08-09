import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../model/request/clip_dayID_post.dart';
import '../../../../../../model/response/md_ClipList_get.dart';
import '../../../../../../service/listClip.dart';
import '../../../../../../service/provider/appdata.dart';
import '../../../../../../widget/image_video.dart';
import '../../../../../../widget/showCilp.dart';

import 'clip_insert_page.dart';

class ClipSelectPage extends StatefulWidget {
  const ClipSelectPage({super.key, required this.did, required this.isVisible});
  final String did;
  final bool isVisible;
  @override
  State<ClipSelectPage> createState() => _ClipSelectPageState();
}

class _ClipSelectPageState extends State<ClipSelectPage> {
  //ClipService
  late Future<void> loadListClipDataMethod;
  late ListClipServices _listClipService;
  List<ListClip> listClips = [];

  //Color
  List<Color> colorClips = [];

  //ListIncrease
  List<ListClip> increaseClips = [];
  List<ClipDayIdPost> increaseClipDays = [];

  String video = "";
  //image vdieo
  // String? _thumbnailFile;
  // String? _thumbnailUrl;

  // Uint8List? _thumbnailData;

  List<String> imageURL = [];
  bool _enabled = true;
  @override
  void initState() {
    super.initState();
    _listClipService = context.read<AppData>().listClipServices;
    loadListClipDataMethod = loadListClipsData();
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
              // color: Colors.white,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          actions: [
            badges.Badge(
              position: badges.BadgePosition.topEnd(top: -7, end: 5),
              showBadge: true,
              ignorePointer: false,
              badgeAnimation: const BadgeAnimation.slide(
                toAnimate: true,
                animationDuration: Duration(seconds: 0),
              ),
              badgeContent: Row(
                children: [
                  if (increaseClips.isNotEmpty)
                    Text(
                      increaseClips.length.toString(),
                      // style: const TextStyle(color: Colors.white),
                    ),
                ],
              ),
              badgeStyle: badges.BadgeStyle(
                //shape: badges.BadgeShape.square,
                badgeColor: Theme.of(context).colorScheme.primary,
                borderSide: const BorderSide(color: Colors.white, width: 2),
                elevation: 0,
              ),
              child: IconButton(
                icon: const Icon(
                  FontAwesomeIcons.cartShopping,
                ),
                onPressed: () {
                  if (increaseClips.isNotEmpty) {
                    Get.to(() => ClipInsertPage(
                          did: widget.did,
                          modelClipList: increaseClips,
                          increaseClip: increaseClipDays,
                          isVisible: widget.isVisible,
                        ));
                  }
                },
              ),
            )
          ],
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: const Text('เลือกคลิปท่าออกกำลังกาย'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Visibility(
                  visible: true,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: showClips(),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  //LoadData
  Future<void> loadListClipsData() async {
    try {
      var datas = await _listClipService.listClips(
          icpID: '', cid: context.read<AppData>().cid.toString(), name: '');
      listClips = datas.data;
      // ignore: unused_local_variable
      for (var index in listClips) {
        // ignore: use_build_context_synchronously
        colorClips.add(context.read<AppData>().colorNotSelect);
        //generateThumbnail(index.video.toString());
      }

      // log("image${listFoods[2].image}");
    } catch (err) {
      log('Error: $err');
    }
  }

  Widget showClips() {
    return FutureBuilder(
      future: loadListClipDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container();
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: listClips.length,
            itemBuilder: (context, index) {
              final listClip = listClips[index];
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Card(
                  color: colorClips[index],
                  child: InkWell(
                    onTap: () {
                      if (colorClips[index] !=
                          context.read<AppData>().colorSelect) {
                        setState(() {
                          // เพิ่มเมนูอาหารนั้นเมือกกดเลือก
                          ListClip request = ListClip(
                              icpId: listClip.icpId,
                              coachId: listClip.coachId,
                              name: listClip.name,
                              details: listClip.details,
                              amountPerSet: listClip.amountPerSet,
                              video: listClip.video);
                          video = listClip.video;
                          _dialog(context, request, colorClips, index);
                          //เปลี่ยนสีเมือเลือกเมนู฿อาหาร
                          // colorFood[index] = Colors.black12;
                        });
                      } else {
                        setState(() {
                          //กลับเป็นสีเดิมเมือเลือกเมนูอาหารซํ้า
                          colorClips[index] =
                              context.read<AppData>().colorNotSelect;
                          //เอาเมนูอาหารที่เลือกออกจาก list model
                          increaseClips.removeWhere(
                              (item) => item.icpId == listClip.icpId);
                          increaseClipDays.removeWhere(
                              (item) => item.listClipId == listClip.icpId);
                        });
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  ),
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.34,
                              child: AutoSizeText(
                                listClip.name,
                                maxLines: 5,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // SizedBox(
                            //   width: MediaQuery.of(context).size.width * 0.4,
                            //   child: AutoSizeText(
                            //     'Calories: ${listFood.calories.toString()}',
                            //     maxLines: 5,
                            //     style: Theme.of(context).textTheme.bodyLarge,
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(
                          width: 50,
                        )
                      ],
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

  void _dialog(
      BuildContext ctx, ListClip listClip, List<Color> colorList, int index) {
    //target widget
    SmartDialog.show(builder: (_) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 50, bottom: 0),
              child: Text("คลิปท่าออกกำลังกาย",
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            if (listClip.video != '') ...{
              WidgetShowCilp(urlVideo: listClip.video),
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
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: AutoSizeText(
                  'ชื่อคลิป: ${listClip.name}',
                  maxLines: 5,
                  //style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: AutoSizeText(
                  'รายละเอียด: ${listClip.details}',
                  maxLines: 5,
                  //style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  'จำนวนเซ็ท: ${listClip.amountPerSet.toString()}',
                  style: Theme.of(context).textTheme.bodyLarge,
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              //MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          increaseClips.add(listClip);

                          ClipDayIdPost requestFoodPost =
                              ClipDayIdPost(listClipId: listClip.icpId);
                          increaseClipDays.add(requestFoodPost);
                          log(jsonEncode(requestFoodPost));

                          colorList[index] =
                              context.read<AppData>().colorSelect;
                        });

                        SmartDialog.dismiss();
                      },
                      child: const Text('ยืนยัน')),
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}

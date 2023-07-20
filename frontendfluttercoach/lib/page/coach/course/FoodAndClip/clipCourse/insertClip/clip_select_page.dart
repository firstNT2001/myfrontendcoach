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

import '../../../../../../model/request/clip_dayID_post.dart';
import '../../../../../../model/response/md_ClipList_get.dart';
import '../../../../../../service/listClip.dart';
import '../../../../../../service/provider/appdata.dart';
import '../../../../../../widget/showCilp.dart';
import '../../course_food_clip.dart';

import 'clip_insert_page.dart';

class ClipSelectPage extends StatefulWidget {
  const ClipSelectPage({super.key, required this.did});
  final  String did;

  @override
  State<ClipSelectPage> createState() => _ClipSelectPageState();
}

class _ClipSelectPageState extends State<ClipSelectPage> {
  //ClipService
  late Future<void> loadListClipDataMethod;
  late ListClipServices _listClipService;
  List<ModelClipList> listClips = [];

  //Color
  List<Color> colorClips = [];

  //ListIncrease
  List<ModelClipList> increaseClips = [];
  List<ClipDayIdPost> increaseClipDays = [];

  String video = "";
  //image vdieo
  // String? _thumbnailFile;
  // String? _thumbnailUrl;

  // Uint8List? _thumbnailData;

  List<String> imageURL = [];
  @override
  void initState() {
    super.initState();
    _listClipService = context.read<AppData>().listClipServices;
    loadListClipDataMethod = loadListClipsData();
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
              Get.to(() => HomeFoodAndClipPage(
                    did: widget.did,
                    sequence: context.read<AppData>().sequence,
                  ));
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
                badgeColor: Theme.of(context).colorScheme.error,
                borderSide: const BorderSide(color: Colors.white, width: 2),
                elevation: 0,
              ),
              child: IconButton(
                icon: const Icon(
                  FontAwesomeIcons.angleRight,
                ),
                onPressed: () {
                  if (increaseClips.isNotEmpty) {
                    Get.to(() => ClipInsertPage(
                          did: widget.did,
                          modelClipList: increaseClips,
                          increaseClip: increaseClipDays,
                        ));
                  }
                },
              ),
            )
          ],
          backgroundColor: Theme.of(context).colorScheme.primary,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: const Text('เลือกเมนูอาหาร'),
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

  // //Image Vdieo
  // void generateThumbnail(String url) async {
  //   File videoTempFile = await copyAssetFile(url);

  //   _thumbnailFile = await VideoThumbnail.thumbnailFile(
  //       video: videoTempFile.path,
  //       thumbnailPath: (await getTemporaryDirectory()).path,
  //       imageFormat: ImageFormat.PNG);
  //   imageURL.add(_thumbnailFile!);
  //   // _thumbnailUrl = await VideoThumbnail.thumbnailFile(
  //   //     video:
  //   //         "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
  //   //     thumbnailPath: (await getTemporaryDirectory()).path,
  //   //     imageFormat: ImageFormat.WEBP);

  //   // _thumbnailData = await VideoThumbnail.thumbnailData(
  //   //   video: videoTempFile2.path,
  //   //   imageFormat: ImageFormat.JPEG,
  //   //   // maxHeight: 300,
  //   //   // maxWidth: 300,
  //   //   quality: 75,
  //   // );

  //   setState(() {});
  // }

  // Future<File> copyAssetFile(String assetFileName) async {
  //   Directory tempDir = await getTemporaryDirectory();
  //   final byteData = await rootBundle.load(assetFileName);

  //   var videoThumbnailFile = File("${tempDir.path}/$assetFileName")
  //     ..createSync(recursive: true)
  //     ..writeAsBytesSync(byteData.buffer
  //         .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  //   return videoThumbnailFile;
  // }

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
          return const Center(child: CircularProgressIndicator());
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
                          ModelClipList request = ModelClipList(
                              icpId: listClip.icpId,
                              coachId: listClip.coachId,
                              name: listClip.name,
                              details: listClip.details,
                              amountPerSet: listClip.amountPerSet,
                              video: listClip.video);
                          video =   listClip.video;
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
                          // Padding(
                          //   padding: const EdgeInsets.only(
                          //       left: 8, top: 5, bottom: 5),
                          //   child: Container(
                          //       width: MediaQuery.of(context).size.width * 0.3,
                          //       height: MediaQuery.of(context).size.height,
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(26),
                          //         image: DecorationImage(
                          //           image: NetworkImage(imageURL[0]),
                          //         ),
                          //       )),
                          // ),
                        } else
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, top: 5, bottom: 5),
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: MediaQuery.of(context).size.height,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(26),
                                    color: Colors.black26)),
                          ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
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

  void _dialog(BuildContext ctx, ModelClipList listClip, List<Color> colorList,
      int index) {
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
            if (listClip.video != '' ) ...{
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

                          ClipDayIdPost requestFoodPost = ClipDayIdPost(
                              listClipId: listClip.icpId);
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

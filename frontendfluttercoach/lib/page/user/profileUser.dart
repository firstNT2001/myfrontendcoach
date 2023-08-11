import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../model/response/md_Customer_get.dart';
import '../../service/customer.dart';
import '../../service/provider/appdata.dart';
import '../../widget/textField/wg_textfile_show.dart';
import 'editProfile.dart';
import 'money/widgethistory/widget_history.dart';

class ProfileUser extends StatefulWidget {
  const ProfileUser({super.key});

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  late CustomerService customerService;
  late Future<void> loadDataMethod;
  List<Customer> customer = [];
  late int uid;

  TextEditingController email = TextEditingController();
  TextEditingController birthday = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController height = TextEditingController();
  TextEditingController fullName = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = context.read<AppData>().uid;
    log("userID" + uid.toString());
    customerService =
        CustomerService(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          showProfile(),
          //Expanded(child: showMenu()),
        ],
      ),
    );
  }

  Widget showProfile() {
    return FutureBuilder(
        future: loadDataMethod, // 3.1 object ของ async method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Stack(
                  children: [
                    Container(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      height: 170,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 65,
                        ),
                        Center(
                          child: CircleAvatar(
                            minRadius: 55,
                            maxRadius: 75,
                            backgroundImage: NetworkImage(customer.first.image),

                            //backgroundImage: NetworkImage(customer.first.image),
                          ),
                        ),
                        Center(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Text("@ " + customer.first.username,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 20),
                                child: Text(customer.first.fullName),
                              ),
                              WidgetTextFieldStringShow(
                                controller: fullName,
                                labelText: 'ชื่อ-นามสกุล',
                              ),
                              WidgetTextFieldStringShow(
                                controller: email,
                                labelText: 'Email',
                              ),
                              WidgetTextFieldStringShow(
                                controller: phone,
                                labelText: 'เบอร์โทรศัพท์',
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: WidgetTextFieldStringShow(
                                      controller: gender,
                                      labelText: 'เพศ',
                                    ),
                                  ),Expanded(
                                    child: WidgetTextFieldStringShow(
                                      controller: birthday,
                                      labelText: 'วันเกิด',
                                    ),
                                  ),
                                ],
                              ),
                               Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: WidgetTextFieldStringShow(
                                      controller: weight,
                                      labelText: 'น้ำหนัก',
                                    ),
                                  ),Expanded(
                                    child: WidgetTextFieldStringShow(
                                      controller: height,
                                      labelText: 'ส่วนสูง',
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10, left: 15, right: 15,top: 15),
                                child: SizedBox(
                                  width: 400,
                                  child: FilledButton(onPressed: (){
                                     Get.to(() => const editProfileCus());
                                  }, child: const Text("แก้ไขข้อมูล")),
                                ),
                              )

                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Future<void> loadData() async {
    try {
      var result =
          await customerService.customer(uid: uid.toString(), email: '');
      customer = result.data;
      fullName.text = customer.first.fullName;
      birthday.text = thaiDate(customer.first.birthday);
      log('เพศ: ${customer.first.gender}');
      if (customer.first.gender == "1") {
        gender.text = "ผู้หญิง";
        log('เพศใหม่1: ${gender.text}');
      } else if (customer.first.gender == "2") {
        gender.text = "ผู้ชาย";
      } else {
        gender.text = "ไม่ได้ระบุ";
      }
      //gender.text = customer.first.gender;
      phone.text = customer.first.phone;
      email.text = customer.first.email;
      weight.text = customer.first.weight.toString();
      height.text = customer.first.height.toString();
    } catch (err) {
      log('Error: $err');
    }
  }
}

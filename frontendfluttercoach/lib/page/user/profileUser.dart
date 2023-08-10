import 'dart:developer';

import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/page/user/money/money.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../model/response/md_Customer_get.dart';
import '../../service/customer.dart';
import '../../service/provider/appdata.dart';
import 'chatOfCus.dart';
import 'editProfile.dart';
import 'money/widgethistory/widget_history.dart';
import 'mycourse/mycourse.dart';

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
      body: Column(
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
                        SizedBox(
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
                          child: Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Text("@ " + customer.first.username,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 20),
                                  child: Text(customer.first.fullName),
                                ),
                                txtfild(fullName, "ชื่อ-นามสกุล"),
                                txtfild(email, "E-mail"),
                                txtfild(phone, "เบอร์โทรศัพท์"),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(child: txtfild(gender, "เพศ")),
                                    Expanded(
                                        child: txtfild(birthday, "วันเกิด"))
                                    
                                  ],
                                ),
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(child: txtfild(weight, "น้ำหนัก")),
                                    Expanded(child: txtfild(height, "ส่วนสูง"))
                                  ],
                                ),

                                //txtfild(weight, "เพศ"),
                                // Row(
                                //   children: [
                                //     SizedBox(width: 20,),
                                //      Icon(
                                //       Icons.phone,
                                //       color:
                                //           Theme.of(context).colorScheme.primary,
                                //       size: 24.0,
                                //     ),
                                //     Padding(
                                //       padding: const EdgeInsets.only(left: 18),
                                //       child: Text(customer.first.phone),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
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

  txtfild(final TextEditingController _controller, String txtTop) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(left: 5, bottom: 3),
          child: Text(
            txtTop,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        TextField(
          readOnly: true,
          controller: _controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            border: OutlineInputBorder(),
          ),
        ),
      ]),
    );
  }
}

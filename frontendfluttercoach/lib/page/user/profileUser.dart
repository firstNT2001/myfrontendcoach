import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/page/user/money/money.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/retrofit.dart';


import '../../model/response/md_Customer_get.dart';
import '../../service/customer.dart';
import '../../service/provider/appdata.dart';
import 'chatOfCus.dart';
import 'editProfile.dart';
import 'mycourse.Detaildart/mycourse.dart';

class ProfileUser extends StatefulWidget {
  const ProfileUser({super.key});

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  late CustomerService customerService;
  late Future<void> loadDataMethod;
  late HttpResponse<Customer> customer;
  int uid = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    customerService =
        CustomerService(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Column(
        children: [
         
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Expanded(child: showProfile()),
          ),
          Expanded(child: showMenu()),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ignore: unnecessary_null_comparison
                if (customer.data.uid != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 25, top: 30),
                    child: Column(
                      children: [                    
                        Row(
                          children: [
                            CircleAvatar(
                              minRadius: 35,
                              maxRadius: 55,
                              backgroundImage:
                                  NetworkImage(customer.data.image),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Text("@ " + customer.data.username),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30),
                                    child: Text(customer.data.fullName),
                                  ),
                                ],
                              ),
                            ),
                              
                        Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: InkWell(
                                onTap: () {
                                  //1. ส่งตัวแปรแบบconstructure
                                  Get.to(() =>  editProfileCus(uid: uid));
                                },
                                child: Icon(
                                  Icons.edit_outlined,
                                  color: Colors.black,
                                  size: 28,
                                ),
                              ),
                        ), 
                          ],
                        ),
                        Container(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.email,
                                      color: Colors.green,
                                      size: 24.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 18),
                                      child: Text(customer.data.fullName),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.phone,
                                      color: Colors.green,
                                      size: 24.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 18),
                                      child: Text(customer.data.phone),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          child: SizedBox(
                            height: 100,
                            width: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("ยอดคงเหลือ"),
                                Text(customer.data.price.toString())
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )

                // Card(
                //   child: ListTile(
                //       leading: CircleAvatar(
                //     radius: 30,
                //     backgroundImage: NetworkImage(customer.data.image),
                //   ),
                //   title: Text("@ "+customer.data.username),
                //   subtitle: Text(customer.data.fullName),
                //   trailing: const Icon(Icons.mode_edit_outline_outlined),
                //   onTap: (){

                //   },),
                // ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget showMenu() {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              log(customer.data.uid.toString());
              context.read<AppData>().uid = customer.data.uid;
              Get.to(() =>  MyCouses());
            },
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Icon(
                      Icons.list_alt_rounded,
                      color: Colors.green,
                      size: 24.0,
                    ),
                  ),
                  Text("รายการซื้อของฉัน"),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              log(customer.data.uid.toString());
              context.read<AppData>().uid = customer.data.uid;
              Get.to(() => const chatOfCustomer());
            },
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Icon(
                      Icons.message_outlined,
                      color: Colors.green,
                      size: 24.0,
                    ),
                  ),
                  Text("ข้อมความ"),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              log(customer.data.uid.toString());
              context.read<AppData>().uid = customer.data.uid;
              Get.to(() => const addCoin());
            },
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Icon(
                      Icons.account_balance_wallet_outlined,
                      color: Colors.green,
                      size: 24.0,
                    ),
                  ),
                  Text("เติมเงิน"),
                ],
              ),
            ),
          ),
          InkWell(
            onLongPress: () {},
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Icon(
                      Icons.logout,
                      color: Colors.redAccent,
                      size: 24.0,
                    ),
                  ),
                  Text("ออกจากระบบ"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loadData() async {
    try {
      customer = await customerService.customer(uid: uid.toString());

      log('cussss: ${customer.data.uid}');
    } catch (err) {
      log('Error: $err');
    }
  }
}

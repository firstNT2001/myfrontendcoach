import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retrofit/retrofit.dart';

import '../../model/modelCustomer.dart';
import '../../service/customer.dart';
import '../../service/provider/appdata.dart';

class editProfileCus extends StatefulWidget {
  //สร้างตัวแปรรับconstructure
  int uid = 0;

  editProfileCus({super.key, required this.uid});

  @override
  State<editProfileCus> createState() => _editProfileCusState();
}

class _editProfileCusState extends State<editProfileCus> {
  //call service
  late Future<void> loadDataMethod;
  late CustomerService customerService;
  late HttpResponse<Customer> customer;
  //controller
  TextEditingController _uid = TextEditingController();
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _fullName = TextEditingController();
  TextEditingController _birthday = TextEditingController();
  TextEditingController _gender = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _image = TextEditingController();
  TextEditingController _weight = TextEditingController();
  TextEditingController _height = TextEditingController();
  TextEditingController _facebookID = TextEditingController();
  TextEditingController _price = TextEditingController();

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
      appBar: AppBar(
        title: Text("แก้ไข"),
      ),
      body: ListView(children: [
        Column(
          children: [showProfile()],
        ),
      ]),
    );
  }

  Future<void> loadData() async {
    try {
      customer = await customerService.customer(widget.uid.toString());

      _uid.text = customer.data.uid.toString();
      _username.text = customer.data.username;
      _fullName.text = customer.data.fullName;
      _email.text = customer.data.email;
      _password.text = customer.data.password;
      _image.text = customer.data.image;
      _facebookID.text = customer.data.facebookId;
      _price.text = customer.data.price.toString();

      log('cus: ${customer.data.uid}');
      log('_username: ${customer.data.username}');
      log('_email: ${customer.data.email}');
      log('message: ${customer.data.fullName}');
    } catch (err) {
      log('Error: $err');
    }
  }

  txtfild(
      final TextEditingController _controller, String lbText, String txtTop) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        txtTop,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      TextField(
        controller: _controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: lbText,
        ),
      ),
    ]);
  }

  Widget showProfile() {
    return FutureBuilder(
        future: loadDataMethod,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  txtfild(_username, "ชื่อผู้ใช้", "ชื่อผู้ใช้"),
                  txtfild(_email, "e-mail", "e-mail"),
                  txtfild(_fullName, "ชื่อ-นามสกุล", "ชื่อ-นามสกุล"),
                  txtfild(_gender, "เพศ", "เพศ"),
                  txtfild(_phone, "โทรศัพท์", "โทรศัพท์"),
                  txtfild(_weight, "น้ำหนัก", "น้ำหนัก"),
                  txtfild(_height, "ส่วนสูง", "ส่วนสูง"),
                  
                ],
              ),
            );
          }
        });
  }
}

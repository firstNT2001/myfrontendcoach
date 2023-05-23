
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/model/request/registerCoachDTO.dart';
import 'package:frontendfluttercoach/model/request/registerCusDTO.dart';

//import 'package:frontendfluttercoach/page/home.dart';
import 'package:frontendfluttercoach/service/register.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:json_serializable/type_helper.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../service/provider/appdata.dart';
import '../auth/login.dart';

// class regFB{
//   final String nameFB;
//   final String emailFB;
//   final String image;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: []),);
  }
}
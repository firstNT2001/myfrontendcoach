import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/service/clip.dart';
import 'package:frontendfluttercoach/service/coach.dart';
import 'package:frontendfluttercoach/service/course.dart';
import 'package:frontendfluttercoach/service/food.dart';
import 'package:frontendfluttercoach/service/listClip.dart';

import '../auth.dart';

import '../buy.dart';
import '../customer.dart';
import '../days.dart';

import '../listFood.dart';
import '../progessbar.dart';
import '../request.dart';
import '../review.dart';

class AppData with ChangeNotifier {
  //Api baseurl
  String baseurl = "https://cslab.it.msu.ac.th:9775";
  String baseUrlGB = "https://api.gbprimepay.com";
  //Color
  //Color colorCard;
  Color colorSelect = Color.fromARGB(255, 170, 168, 167);
  Color colorNotSelect = Color.fromARGB(255, 255, 255, 255);

  Map<String, dynamic> userFacebook = {};

  
  int coID = 0;
  //bill
  int bill =0;
  // coach
  int cid = 0;
  String qualification = "";
  String nameCoach = " ";
  String usercoach = " ";
  String propertycoach = " ";

  //course
  int idcourse = 0;
  String img = "";
  String namecourse = "";
  String namecoach = "";
  String detail = "";
  String exdate = "";
  int day = 0;
  
  //user
  int uid = 0;
  String nameCus = " ";
  int money = 0;

  //Day
  int did = 0;
  String sequence = "";
  //requests
  String rqID = "";

  int duration = 1;

  FoodServices get foodServices => FoodServices(Dio(), baseUrl: baseurl);
  ListFoodServices get listfoodServices =>
      ListFoodServices(Dio(), baseUrl: baseurl);
  ClipServices get clipServices => ClipServices(Dio(), baseUrl: baseurl);
  ListClipServices get listClipServices =>
      ListClipServices(Dio(), baseUrl: baseurl);

  AuthService get authService => AuthService(Dio(), baseUrl: baseurl);
  CourseService get courseService => CourseService(Dio(), baseUrl: baseurl);
  CoachService get coachService => CoachService(Dio(), baseUrl: baseurl);
  RequestService get requestService => RequestService(Dio(), baseUrl: baseurl);
  DaysService get daysService => DaysService(Dio(), baseUrl: baseurl);
  ReviewService get reviewService => ReviewService(Dio(), baseUrl: baseurl);
  BuyCourseService get buyCourseService =>
      BuyCourseService(Dio(), baseUrl: baseurl);
  CustomerService get customerService =>
      CustomerService(Dio(), baseUrl: baseurl);
  ProgessbarService get progessbar =>
      ProgessbarService(Dio(), baseUrl: baseurl);
}

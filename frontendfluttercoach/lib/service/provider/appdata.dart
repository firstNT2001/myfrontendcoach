import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/service/coach.dart';
import 'package:frontendfluttercoach/service/course.dart';
import 'package:frontendfluttercoach/service/food.dart';
import 'package:frontendfluttercoach/service/listClip.dart';

import '../auth.dart';
import '../days.dart';
import '../listFood.dart';
import '../request.dart';

class AppData with ChangeNotifier {
  //Api baseurl
  String baseurl = "http://202.28.34.197:9775";

  Map<String,dynamic> userFacebook = {} ; 
  int coID = 0;

  // coach
  int cid =0;
  String qualification = "";
  String nameCoach = " ";
  String usercoach = " ";
  String propertycoach = " ";

  //course
  int idcourse = 0;

  //user
  int uid = 0;
  String nameCus = " ";
  int money = 0;
  
  FoodServices get foodServices => FoodServices(Dio(), baseUrl: baseurl);
  ListFoodServices get listfoodServices => ListFoodServices(Dio(), baseUrl: baseurl);
  ListClipServices get listClipServices => ListClipServices(Dio(), baseUrl: baseurl);
  AuthService get authService => AuthService(Dio(), baseUrl: baseurl);
  CourseService get courseService => CourseService(Dio(), baseUrl: baseurl);
  CoachService get couchService =>CoachService(Dio(), baseUrl: baseurl);  
  RequestService get requestService => RequestService(Dio(), baseUrl: baseurl);
  DaysService get daysService => DaysService(Dio(), baseUrl: baseurl);

}
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
//import 'package:frontendfluttercoach/sevice/destination.dart';
import 'package:frontendfluttercoach/model/login.dart';

part 'login.g.dart';

@RestApi()
abstract class LoginService {
  factory LoginService(Dio dio, {String baseUrl}) = _LoginService;

  @GET("/login")
  Future<List<Login>> getDestinations();

}


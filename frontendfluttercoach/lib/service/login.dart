import 'package:frontendfluttercoach/model/modelCoach.dart';
import 'package:frontendfluttercoach/model/modelCustomer.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:frontendfluttercoach/model/DTO/loginDTO.dart';

import '../model/DTO/loginFBDTO.dart';
import '../model/modelCidAndUid.dart';


part 'generated/login.g.dart';

@RestApi()
abstract class LoginService {
  factory LoginService(Dio dio, {String baseUrl}) = _LoginService;

  @POST("/user/login")
  Future<HttpResponse<ModelCidAndUid>> login(@Body() LoginDto login);
  
  @POST("/user/loginfb")
  Future<HttpResponse<ModelCidAndUid>> loginfb(@Body() LoginFbDto login);
  //Future<HttpResponse<Customer>> loginfbCus(@Body() LoginFbDto login);
 
}
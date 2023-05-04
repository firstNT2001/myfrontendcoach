
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:frontendfluttercoach/model/request/loginDTO.dart';

import '../model/request/loginFBDTO.dart';
import '../model/response/md_CidAndUid.dart';


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
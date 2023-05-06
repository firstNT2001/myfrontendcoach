
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';


import '../model/request/auth_login_post.dart';
import '../model/response/auth_login_res.dart';



part 'generated/auth.g.dart';

@RestApi()
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  @POST("/auth/login")
  Future<HttpResponse<AuthLoginRes>> login(@Body() AuthLoginPost authLoginPost);
 
  //  @POST("/user/loginfb")
  // Future<HttpResponse<ModelCidAndUid>> loginfb(@Body() LoginFbDto login);
  // //Future<HttpResponse<Customer>> loginfbCus(@Body() LoginFbDto login);
 
}
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../model/request/auth_login_post.dart';
import '../model/request/auth_password.dart';
import '../model/request/registerCoachDTO.dart';
import '../model/request/registerCusDTO.dart';
import '../model/response/auth_login_res.dart';
import '../model/response/md_Result.dart';

part 'generated/auth.g.dart';

@RestApi()
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  @POST("/auth/login")
  Future<HttpResponse<AuthLoginRes>> login(@Body() AuthLoginPost authLoginPost);

  //  @POST("/user/loginfb")
  // Future<HttpResponse<ModelCidAndUid>> loginfb(@Body() LoginFbDto login);
  // //Future<HttpResponse<Customer>> loginfbCus(@Body() LoginFbDto login);
  @POST("/auth/Coach")
  Future<HttpResponse<ModelResult>> regCoach(
      @Body() RegisterCoachDto registerCoachDto);

 @POST("/auth/Cus")
  Future<HttpResponse<ModelResult>> regCus(
      @Body() RegisterCusDto registerCusDto);

  @PUT("/auth/Coach/{cid}")
  Future<HttpResponse<ModelResult>> updateCoach(
      @Path() String cid, @Body() RegisterCoachDto registerCoachDto);

   @PUT("/auth/password/Coach/{cid}")
  Future<HttpResponse<ModelResult>> passwordCoach(
      @Path() String cid, @Body() AuthPassword authPassword);

   @PUT("/auth/password/Cus/{uid}")
  Future<HttpResponse<ModelResult>> passwordCus(
      @Path() String uid, @Body() AuthPassword authPassword);
}

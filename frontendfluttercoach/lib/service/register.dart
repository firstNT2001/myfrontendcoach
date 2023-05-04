import 'package:frontendfluttercoach/model/request/registerCoachDTO.dart';
import 'package:frontendfluttercoach/model/request/registerCusDTO.dart';

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../model/response/md_CidAndUid.dart';



part 'generated/register.g.dart';

@RestApi()
abstract class RegisterService {
  factory RegisterService(Dio dio, {String baseUrl}) = _RegisterService;

  @POST("/user/registerCus")
  Future<HttpResponse<ModelCidAndUid>> regCusService(@Body() RegisterCusDto reg);

  @POST("/user/registerCoach")
  Future<HttpResponse<ModelCidAndUid>> regCoachService(@Body() RegisterCoachDto reg);
  
}
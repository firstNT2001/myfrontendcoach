import 'package:frontendfluttercoach/model/DTO/registerCoachDTO.dart';
import 'package:frontendfluttercoach/model/DTO/registerCusDTO.dart';
import 'package:frontendfluttercoach/model/modelCoach.dart';
import 'package:frontendfluttercoach/model/modelCustomer.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../model/modelCidAndUid.dart';



part 'generated/register.g.dart';

@RestApi()
abstract class RegisterService {
  factory RegisterService(Dio dio, {String baseUrl}) = _RegisterService;

  @POST("/user/registerCus")
  Future<HttpResponse<ModelCidAndUid>> regCusService(@Body() RegisterCusDto reg);

  @POST("/user/registerCoach")
  Future<HttpResponse<ModelCidAndUid>> regCoachService(@Body() RegisterCoachDto reg);
  
}
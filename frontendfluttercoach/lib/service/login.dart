import 'package:frontendfluttercoach/model/modelCoach.dart';
import 'package:frontendfluttercoach/model/modelCustomer.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:frontendfluttercoach/model/DTO/loginDTO.dart';


part 'login.g.dart';

@RestApi()
abstract class LoginService {
  factory LoginService(Dio dio, {String baseUrl}) = _LoginService;

  @POST("/user/login")
  Future<HttpResponse<Customer>> loginCus(@Body() LoginDto login);

  @POST("/user/login")
  Future<HttpResponse<Coach>> loginCoach(@Body() LoginDto login);
  
}
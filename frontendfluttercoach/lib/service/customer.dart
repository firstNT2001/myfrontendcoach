import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';


import '../model/response/md_Course_get.dart';
import '../model/response/md_RowsAffected.dart';


part 'generated/customer.g.dart';


@RestApi()
abstract class CustomerService {
  factory CustomerService(Dio dio, {String baseUrl}) = _CustomerService;

  @GET("/user2/customer/{uid}")
  Future<HttpResponse<Customer>> customer(@Path("uid") String uid);

  @PUT("/user2/updateCus")
   Future<HttpResponse<ModelRowsAffected>> updateCus(@Body() Customer cusUpdate);

}
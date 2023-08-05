import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../model/request/updateCus.dart';
import '../model/response/md_Customer_get.dart';
import '../model/response/md_Result.dart';

part 'generated/customer.g.dart';

@RestApi()
abstract class CustomerService {
  factory CustomerService(Dio dio, {String baseUrl}) = _CustomerService;

  @GET("/user")
  Future<HttpResponse<Customer>> customer(
      {@Query("uid") required String uid,
      @Query("email") required String email});

  @PUT("/user/{uid}")
  Future<HttpResponse<ModelResult>> updateCustomer(
      @Path("uid") String uid, @Body() UpdateCustomer cusUpdate);
}

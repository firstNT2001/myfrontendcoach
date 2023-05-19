import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';


import '../model/request/updateCus.dart';
import '../model/response/md_Customer_get.dart';
import '../model/response/md_RowsAffected.dart';


part 'generated/customer.g.dart';


@RestApi()
abstract class CustomerService {
  factory CustomerService(Dio dio, {String baseUrl}) = _CustomerService;

  @GET("/user")
  Future<HttpResponse<Customer>> customer(
    @Query("uid") String uid );

  @PUT("/user2/updateCus")
   Future<HttpResponse<ModelRowsAffected>> updateCus(@Body() UpdateCustomer cusUpdate);

}
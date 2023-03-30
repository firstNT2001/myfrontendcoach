import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:frontendfluttercoach/model/modelCustomer.dart';


part 'generated/customer.g.dart';


@RestApi()
abstract class CustomerService {
  factory CustomerService(Dio dio, {String baseUrl}) = _CustomerService;

  @GET("/user2/customer/{uid}")
  Future<HttpResponse<Customer>> customer(@Path("uid") String uid);

}
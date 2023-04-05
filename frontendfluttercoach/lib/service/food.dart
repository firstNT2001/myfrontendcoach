import 'package:frontendfluttercoach/model/modelRowsAffected.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:frontendfluttercoach/model/modelCustomer.dart';

import '../model/DTO/foodDTO.dart';
import '../model/modelListFood.dart';


part 'generated/food.g.dart';


@RestApi()
abstract class FoodService {
  factory FoodService(Dio dio, {String baseUrl}) = _FoodService;

  @GET("/listFood/{cid}")
  Future<HttpResponse<List<ModelListFood>>> listFoods(@Path("cid") String cid);

  @POST("/listFood/insertListFood")
  Future<HttpResponse<ModelRowsAffected>> insertListFood(@Body() FoodDto food);
}
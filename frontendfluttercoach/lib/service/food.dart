import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';


import '../model/DTO/listFoodDTO.dart';
import '../model/modelListFood.dart';
import '../model/modelRowsAffected.dart';


part 'generated/food.g.dart';


@RestApi()
abstract class FoodServices {
  factory FoodServices(Dio dio, {String baseUrl}) = _FoodServices;

  @GET("/listFood/{cid}")
  Future<HttpResponse<List<ModelListFood>>> listFoods(@Path("cid") String cid);

  @POST("/listFood/insertListFood")
  Future<HttpResponse<ModelRowsAffected>> insertListFood(@Body() ListFoodDto food);

}
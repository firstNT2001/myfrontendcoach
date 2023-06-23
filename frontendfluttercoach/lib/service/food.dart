import 'package:dio/dio.dart';

import 'package:retrofit/retrofit.dart';

import '../model/request/food_dayID_post.dart';

import '../model/request/food_foodID_put.dart';
import '../model/response/food_get_res.dart';

import '../model/response/md_Result.dart';

part 'generated/food.g.dart';

@RestApi()
abstract class FoodServices {
  factory FoodServices(Dio dio, {String baseUrl}) = _FoodServices;

  @GET("/food")
  Future<HttpResponse<List<ModelFood>>> foods(
      {@Query("fid") required String fid,
      @Query("ifid") required String ifid,
      @Query("did") required String did,
      @Query("name") required String name});

  @POST("/food/dayID/{did}")
  Future<HttpResponse<ModelResult>> insertFoodByDayID(
      @Path() String did,
      @Body() FoodDayIdPost foodDayIdPost);

  @PUT("/food/foodID/{fid}")
  Future<HttpResponse<ModelResult>> updateFoodByFoodID(
      @Path() String fid,
      @Body() FoodFoodIdPut foodFoodIdPut);

   @DELETE("/food/foodID/{fid}")
  Future<HttpResponse<ModelResult>> deleteFood(@Path() String fid);
}

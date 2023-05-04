import 'package:dio/dio.dart';

import 'package:retrofit/retrofit.dart';

import '../model/request/listFood_foodID_put.dart';

import '../model/request/listFood_coachID_post.dart';
import '../model/response/md_FoodList_get.dart';
import '../model/response/md_Result.dart';

part 'generated/listFood.g.dart';

@RestApi()
abstract class ListFoodServices {
  factory ListFoodServices(Dio dio, {String baseUrl}) = _ListFoodServices;

  @GET("/listFood")
  Future<HttpResponse<List<ModelFoodList>>> listFoods(
      {@Query("ifid") required String ifid,
      @Query("cid") required String cid,
      @Query("name") required String name});

  @POST("/listFood/coachID/{cid}")
  Future<HttpResponse<ModelResult>> insertListFoodByCoachID(
      @Path("cid") String cid,
      @Body() ListFoodCoachIdPost listFoodCoachIdPost);

  @PUT("/listFood/foodID/{ifid}")
  Future<HttpResponse<ModelResult>> updateListFoodByFoodID(
      @Path("ifid") String ifid,
      @Body() ListFoodFoodIdPut listFoodFoodIdPut);
}

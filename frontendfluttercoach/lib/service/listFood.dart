
import 'package:dio/dio.dart';

import 'package:retrofit/retrofit.dart';

import '../model/DTO/ListFoodPutRequest.dart';

import '../model/ModelFoodList.dart';
import '../model/DTO/ListFoodPostRequest.dart';
import '../model/modelResult.dart';



part 'generated/listFood.g.dart';

@RestApi()
abstract class ListFoodServices {
  factory ListFoodServices(Dio dio, {String baseUrl}) = _ListFoodServices;

   @GET("/listFood/{cid}")
  Future<HttpResponse<List<ModelFoodList>>> listFoods(@Path("cid") String cid);

  @GET("/listFood/foodID/{ifid}")
  Future<HttpResponse<ModelFoodList>> listFood(@Path("ifid") String ifid);

  @POST("/listFood/insertListFood")
  Future<HttpResponse<ModelResult>> insertListFood(@Body() ListFoodPostRequest listFoodPostRequest);
  
  @PUT("/listFood/updateListFood")
  Future<HttpResponse<ModelResult>> updateListFood(@Body() ListFoodPutRequest listFoodPutRequest);
}
import 'dart:ffi';

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../model/request/insertReview.dart';
import '../model/response/md_Result.dart';
import '../model/response/md_Review_get.dart';
import '../model/response/scorcoach.dart';

part 'generated/review.g.dart';

@RestApi()
abstract class ReviewService {
  factory ReviewService(Dio dio, {String baseUrl}) = _ReviewService;
  @GET("/review")
  Future<HttpResponse<List<ModelReview>>> review(
      {@Query("coID") required String coID});

  @POST("/review/{bid}")
  Future<HttpResponse<ModelResult>> insertreview(
      @Path() String bid, @Body() InsertReview insertReview);
  
  @GET("/review/{cid}")
  Future<HttpResponse<Scorecoach>> scorecoach(
      @Path("cid") String cid);
}

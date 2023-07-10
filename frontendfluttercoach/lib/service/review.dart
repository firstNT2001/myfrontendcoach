import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../model/request/insertReview.dart';
import '../model/response/md_Result.dart';
import '../model/response/md_Review_get.dart';

part 'generated/review.g.dart';

@RestApi()
abstract class ReviewService {
  factory ReviewService(Dio dio, {String baseUrl}) = _ReviewService;
  @GET("/review")
  Future<HttpResponse<List<ModelReview>>> review(
      {@Query("coID") required String coID});

  @POST("/review/{uid}")
  Future<HttpResponse<ModelResult>> insertreview(
      @Path() String uid, @Body() InsertReview insertReview);
}

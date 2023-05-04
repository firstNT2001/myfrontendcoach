
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../model/response/md_Review_get.dart';


part 'generated/review.g.dart';

@RestApi()
abstract class ReviewService {
  factory ReviewService(Dio dio, {String baseUrl}) = _ReviewService;
  @GET("/user2/getReviewByCoID/{coID}")
  Future<HttpResponse<List<ModelReview>>> getReviewByCoID(@Path("coID") String coID);
}
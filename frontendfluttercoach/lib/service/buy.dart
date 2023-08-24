import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../model/request/buycourse_coID_post.dart';
import '../model/response/md_Buying_get.dart';
import '../model/response/md_Result.dart';

part 'generated/buy.g.dart';

@RestApi()
abstract class BuyCourseService {
  factory BuyCourseService(Dio dio, {String baseUrl}) = _BuyCourseService;

  @POST("/buycourse/{coID}")
  Future<HttpResponse<ModelResult>> buyCourse(
      @Path("coID") String coID, @Body() BuyCoursecoIdPost buyCoursecoId);

  @GET("/buy/user/{cid}")
  Future<HttpResponse<List<Buying>>> courseUsers({@Path() required String cid});

  @GET("/buy/count")
  Future<HttpResponse<int>> amountUserinCourse(
      {@Query("originalID") required String originalID});

  @GET("/buy")
  Future<HttpResponse<List<Buying>>> buying(
      {@Query("uid") required String uid,
      @Query("coID") required String coID,
      @Query("cid") required String cid,
      @Query("bid") required String bid});
}

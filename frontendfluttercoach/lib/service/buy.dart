import 'package:frontendfluttercoach/model/response/course_get_res.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../model/request/buycourse_coID_post.dart';
import '../model/response/md_Buying_get.dart';

part 'generated/buy.g.dart';

@RestApi()
abstract class BuyCourseService {
  factory BuyCourseService(Dio dio, {String baseUrl}) = _BuyCourseService;

  @POST("/buycourse/{coID}")
  Future<HttpResponse<ModelCourse>> buyCourse(
      @Path("coID") String coID, @Body() BuyCoursecoIdPost buyCoursecoId);
      
  @GET("/buy/user/{cid}")
  Future<HttpResponse<List<Buying>>> courseUsers({@Path() required String cid});
}

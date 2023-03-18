import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../model/DTO/updateCourseDTO.dart';
import '../model/modelCourse.dart';

part 'generated/course.g.dart';


@RestApi()
abstract class CourseService {
  factory CourseService(Dio dio, {String baseUrl}) = _CourseService;

  @GET("/course/getCourseByIDCoach/{cid}")
  Future<HttpResponse<List<ModelCourse>>> getCourseByCid(@Path("cid") String cid);

  @GET("/course/getCourseByCoID/{coID}")
  Future<HttpResponse<ModelCourse>> getCourseByCoID(@Path("coID") String coID);

  @GET("/course/getCourseByName/{name}")
  Future<HttpResponse<List<ModelCourse>>> getCourseByName(@Path("name") String name);
 
  @POST("/course/updateCourse")
  Future<HttpResponse<ModelCourse>> updateCourse(@Body() UpdateCourse login);
}
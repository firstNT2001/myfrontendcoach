import 'package:frontendfluttercoach/model/DTO/insertCourseDTO.dart';
import 'package:frontendfluttercoach/model/modelResult.dart';
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

  @GET("/user2/mycourse/{uid}")
  Future<HttpResponse<List<ModelCourse>>> getCourseByUid(@Path("uid")String uid);
 
  @PUT("/course/updateCourse")
  Future<HttpResponse<ModelResult>> updateCourse(@Body() UpdateCourse courseUpdate);

  @POST("/course/insertCourse")
  Future<HttpResponse<ModelResult>> insetCourse(@Body() InsertCourseDto courseInset);
}
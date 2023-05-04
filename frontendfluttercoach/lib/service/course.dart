import 'package:frontendfluttercoach/model/request/course_coachID_post.dart';
import 'package:frontendfluttercoach/model/request/course_courseID_put.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../model/response/md_Course_get.dart';
import '../model/response/md_Result.dart';

part 'generated/course.g.dart';

@RestApi()
abstract class CourseService {
  factory CourseService(Dio dio, {String baseUrl}) = _CourseService;

  @GET("/course")
  Future<HttpResponse<List<ModelCourse>>> course(
      {@Query("coID") required String coID,
      @Query("cid") required String cid,
      @Query("name") required String name});

  @PUT("/course/courseID/{coID}")
  Future<HttpResponse<ModelResult>> updateCourseByCourseID(
      @Path("coID") String coID, @Body() CourseCourseIdPut courseCourseIdPut);

  @POST("/course/coachID/{cid}")
  Future<HttpResponse<ModelResult>> insetCourseByCoachID(
      @Path("cid") String cid, @Body() CourseCoachIdPost courseCoachIdPost);
}

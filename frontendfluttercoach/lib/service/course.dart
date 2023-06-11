import 'package:frontendfluttercoach/model/request/course_coachID_post.dart';
import 'package:frontendfluttercoach/model/request/course_courseID_put.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../model/response/course_get_res.dart';
import '../model/response/md_Result.dart';
import '../model/response/md_coach_course_get.dart';

part 'generated/course.g.dart';

@RestApi()
abstract class CourseService {
  factory CourseService(Dio dio, {String baseUrl}) = _CourseService;

  @GET("/course")
  Future<HttpResponse<List<Coachbycourse>>> course(
      {@Query("coID") required String coID,
      @Query("cid") required String cid,
      @Query("name") required String name});

  @GET("/courses")
  Future<HttpResponse<List<Coachbycourse>>> courseByUid({@Query("uid") required String uid,});

  @PUT("/course/courseID/{coID}")
  Future<HttpResponse<ModelResult>> updateCourseByCourseID(
      @Path("coID") String coID, @Body() CourseCourseIdPut courseCourseIdPut);

  @POST("/course/coachID/{cid}")
  Future<HttpResponse<ModelResult>> insetCourseByCoachID(
      @Path("cid") String cid, @Body() CourseCoachIdPost courseCoachIdPost);

  @DELETE("/course/courseID/{coID}")
  Future<HttpResponse<ModelResult>> deleteCourse(@Path() String coID);
}

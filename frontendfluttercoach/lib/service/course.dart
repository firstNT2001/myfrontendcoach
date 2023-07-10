import 'package:frontendfluttercoach/model/request/course_coachID_post.dart';
import 'package:frontendfluttercoach/model/request/course_courseID_put.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../model/request/course_EX.dart';
import '../model/request/status_clip.dart';
import '../model/response/clip_get_res.dart';
import '../model/response/md_Result.dart';
import '../model/response/md_coach_course_get.dart';
import '../model/response/md_course_buy.dart';

part 'generated/course.g.dart';

@RestApi()
abstract class CourseService {
  factory CourseService(Dio dio, {String baseUrl}) = _CourseService;

  @GET("/course/progess/{coID}")
  Future<HttpResponse<List<ModelClip>>> progess(
      @Path("coID") String coID);

  @GET("/course")
  Future<HttpResponse<List<Coachbycourse>>> course(
      {@Query("coID") required String coID,
      @Query("cid") required String cid,
      @Query("name") required String name});

  @GET("/course/sell/{coID}")
  Future<HttpResponse<Coachbycourse>> coursebyCoID(
       @Path("coID") String coID);

  @GET("/courses")
  Future<HttpResponse<List<CourseGetCus>>> showcourseNotEx({
    @Query("uid") required String uid,
  });

  @GET("/courses/EX")
  Future<HttpResponse<List<CourseGetCus>>> showcourseEx({
    @Query("uid") required String uid,
  });

  @PUT("/course/courseID/{coID}")
  Future<HttpResponse<ModelResult>> updateCourseByCourseID(
      @Path("coID") String coID, @Body() CourseCourseIdPut courseCourseIdPut);
  @PUT("/courses/clip/{cpID}")
  Future<HttpResponse<ModelResult>> updateStatusClip(
      @Path("cpID") String cpID, @Body() StatusClip statusClip);

  @POST("/course/coachID/{cid}")
  Future<HttpResponse<ModelResult>> insetCourseByCoachID(
      @Path("cid") String cid, @Body() CourseCoachIdPost courseCoachIdPost);

  @PUT("/course/expiration/{coID}")
  Future<HttpResponse<ModelResult>> updateCourseExpiration(
       @Path("coID") String coID, @Body() CourseExpiration courseExpiration);

  @DELETE("/course/courseID/{coID}")
  Future<HttpResponse<ModelResult>> deleteCourse(@Path() String coID);
}

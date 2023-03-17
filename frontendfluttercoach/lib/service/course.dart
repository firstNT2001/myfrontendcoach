import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../model/modelCourse.dart';

part 'course.g.dart';


@RestApi()
abstract class CourseService {
  factory CourseService(Dio dio, {String baseUrl}) = _CourseService;

  @GET("/course/getCourseByIDCoach/{cid}")
  Future<HttpResponse<ModelCourse>> getCoachByCid(@Path("cid") String cid);

  

 
}
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../model/modelCourse.dart';

part 'generated/course.g.dart';


@RestApi()
abstract class CourseService {
  factory CourseService(Dio dio, {String baseUrl}) = _CourseService;

  @GET("/course/getCourseByIDCoach/{cid}")
  Future<HttpResponse<List<ModelCourse>>> getCoachByCid(@Path("cid") String cid);

  @GET("/course/getCourseByCoID/{coID}")
  Future<HttpResponse<ModelCourse>> getCoachByCoID(@Path("coID") String coID);

   @GET("/course/getCourseByName/{name}")
  Future<HttpResponse<List<ModelCourse>>> getCoachByName(@Path("name") String name);
 
}
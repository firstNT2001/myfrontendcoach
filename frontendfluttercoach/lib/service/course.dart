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
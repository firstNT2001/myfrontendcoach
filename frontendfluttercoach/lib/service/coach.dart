import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../model/response/md_Coach_get.dart';

part 'generated/coach.g.dart';

@RestApi()
abstract class CoachService {
  factory CoachService(Dio dio, {String baseUrl}) = _CoachService;

  @GET("/coach")
  Future<HttpResponse<List<Coach>>> coach({
    @Query("username") required String nameCoach,
    @Query("cid") required String cid,
    @Query("email") required String email
  });

}

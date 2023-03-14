import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import 'package:frontendfluttercoach/model/modelCoach.dart';

part 'coach.g.dart';

@RestApi()
abstract class CoachService {
  factory CoachService(Dio dio,{String baseUrl}) = _CoachService;

  @GET("/user2/getCoachByName/{name}")
  Future<HttpResponse<List<Coach>>> getNameCoach(@Path("name") String nameCoach);
}
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../model/response/md_Day_showmycourse.dart';

part 'generated/day.g.dart';
@RestApi()
abstract class DayService {
  factory DayService(Dio dio, {String baseUrl}) = _DayService;

  @GET("/day")
  Future<HttpResponse<List<DayDetail>>> day(
      {
      @Query("did") required String did,
      @Query("coID") required String coID,
      @Query("sequence") required String sequence});

  
}
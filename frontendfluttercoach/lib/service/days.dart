import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../model/request/day_dayID_put.dart';
import '../model/response/md_Result.dart';
import '../model/response/md_days.dart';

part 'generated/days.g.dart';

@RestApi()
abstract class DaysService {
  factory DaysService(Dio dio, {String baseUrl}) = _DaysService;

  @GET("/day")
  Future<HttpResponse<List<ModelDay>>> days(
      {@Query("did") required String did,
      @Query("coID") required String coID,
      @Query("sequence") required String sequence});

  @POST("/day/courseID/{coID}")
  Future<HttpResponse<ModelResult>> insertDayByCourseID(
      @Path() String coID,
      @Body() DayDayIdPut dayDayIdPut);

  @PUT("/day/dayID/{did}")
  Future<HttpResponse<ModelResult>> updateDayByDayID(
      @Path() String did, @Body() DayDayIdPut dayDayIdPut);

  @DELETE("/day/dayID/{did}")
  Future<HttpResponse<ModelResult>> deleteDay(@Path() String did);

}

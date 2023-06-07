
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

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
 
}
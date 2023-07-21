import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../model/request/userRequest.dart';
import '../model/response/md_Result.dart';
import '../model/response/md_request.dart';

part 'generated/request.g.dart';

@RestApi()
abstract class RequestService {
  factory RequestService(Dio dio, {String baseUrl}) = _RequestService;

  @GET("/request")
  Future<HttpResponse<List<Request>>> request(
      {@Query("rqID") required String rqID,
      @Query("uid") required String uid,
      @Query("cid") required String cid});

  @POST("/request/{uid}")
  Future<HttpResponse<ModelResult>> insertRequest(
      @Path("uid") String uid, @Body() UserRequest userRequest);
}

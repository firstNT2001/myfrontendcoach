
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../model/response/md_request.dart';

part 'generated/request.g.dart';

@RestApi()
abstract class RequestService {
  factory RequestService(Dio dio, {String baseUrl}) = _RequestService;

   @GET("/request")
  Future<HttpResponse<List<ModelRequest>>> request(
      {@Query("rqID") required String rqID,
      @Query("uid") required String uid,
      @Query("cid") required String cid});
  
}
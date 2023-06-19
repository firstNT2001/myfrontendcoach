import 'dart:ffi';

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../model/request/rq_gbprime.dart';
import '../model/request/wallet_uid.dart';
import '../model/response/image_res_Gbprime.dart';


part 'generated/gbprime.g.dart';

@RestApi()
abstract class GbprimeService {
  factory GbprimeService(Dio dio, {String baseUrlGB}) = _GbprimeService;
  @FormUrlEncoded()
  @POST("/v3/qrcode")
  Future<HttpResponse<RestGbprime>> ImageGB(
    @Field("token") String token,
    @Field("referenceNo") String referenceNo,
    @Field("backgroundUrl") String backgroundUrl,
    @Field("amount") Double amount,
    @Body() RqGbprime rqGbprime );
}
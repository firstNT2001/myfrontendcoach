import 'package:dio/dio.dart';
import 'package:frontendfluttercoach/model/request/listClip_clipID_put.dart';

import 'package:retrofit/retrofit.dart';

import '../model/request/clip_clipID_put.dart';
import '../model/request/clip_dayID_post.dart';
import '../model/response/md_ClipList_get.dart';
import '../model/response/md_Result.dart';

part 'generated/clip.g.dart';

@RestApi()
abstract class ClipServices {
  factory ClipServices(Dio dio, {String baseUrl}) = _ClipServices;

  @GET("/clip")
  Future<HttpResponse<List<ModelClipList>>> clips(
      {@Query("cpID") required String cpID,
      @Query("icpID") required String icpID,
      @Query("did") required String did});

  @POST("/clip/dayID/{did}")
  Future<HttpResponse<ModelResult>> insertClipByDayID(
      @Path() String did, @Body() ClipDayIdPost clipDayIdPost);

  @PUT("/clip/clipID/{cpID}")
  Future<HttpResponse<ModelResult>> updateClipByClipID(
      @Path() String cpID, @Body() ClipClipIdPut clipClipIdPut);

  @DELETE("/clip/clipID/{cpID}")
  Future<HttpResponse<ModelResult>> deleteClip(@Path() String cpID);
}

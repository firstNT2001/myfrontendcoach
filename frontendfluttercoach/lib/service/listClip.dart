import 'package:dio/dio.dart';

import 'package:retrofit/retrofit.dart';

import '../model/request/listClip_coachID_post.dart';
import '../model/response/md_ClipList_get.dart';
import '../model/response/md_Result.dart';

part 'generated/listClip.g.dart';

@RestApi()
abstract class ListClipServices {
  factory ListClipServices(Dio dio, {String baseUrl}) = _ListClipServices;

  @GET("/listClip")
  Future<HttpResponse<List<ModelClipList>>> listClips(
      {@Query("icpID") required String icpID,
      @Query("cid") required String cid,
      @Query("name") required String name});

  @POST("/listClip/coachID/{cid}")
  Future<HttpResponse<ModelResult>> insertListClipByCoachID(
      @Path("cid") String cid,
      @Body() ListClipCoachIdPost listClipCoachIdPost);

}
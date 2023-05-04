import 'package:dio/dio.dart';

import 'package:retrofit/retrofit.dart';

import '../model/response/md_ClipList_get.dart';

part 'generated/listClip.g.dart';

@RestApi()
abstract class ListClipServices {
  factory ListClipServices(Dio dio, {String baseUrl}) = _ListClipServices;

  @GET("/listClip")
  Future<HttpResponse<List<ModelClipList>>> listClips(
      {@Query("icpID") required String icpID,
      @Query("cid") required String cid,
      @Query("name") required String name});
}

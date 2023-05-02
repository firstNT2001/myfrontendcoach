
import 'package:dio/dio.dart';

import 'package:retrofit/retrofit.dart';

import '../model/modelClipList.dart';




part 'generated/listClip.g.dart';

@RestApi()
abstract class ListClipServices {
  factory ListClipServices(Dio dio, {String baseUrl}) = _ListClipServices;

   @GET("/listClip/{cid}")
  Future<HttpResponse<List<ModelClipList>>> listClips(@Path("cid") String cid);


}
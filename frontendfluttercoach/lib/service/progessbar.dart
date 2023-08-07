
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../model/response/md_process.dart';

part 'generated/progessbar.g.dart';

@RestApi()
abstract class ProgessbarService {
  factory ProgessbarService(Dio dio, {String baseUrl}) = _ProgessbarService;
  @GET("/course/progess")
  Future<HttpResponse<Modelprogessbar>> processbar(
      {@Query("coID") required String coID});

}

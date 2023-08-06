import 'dart:ffi';

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'generated/progessbar.g.dart';

@RestApi()
abstract class ProgessbarService {
  factory ProgessbarService(Dio dio, {String baseUrl}) = _ProgessbarService;
  @GET("/course/progess")
  Future<HttpResponse<Double>> processbar(
      {@Query("coID") required String coID});

}

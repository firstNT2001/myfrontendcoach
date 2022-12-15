import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:frontendfluttercoach/sevice/destination.dart';
import 'package:frontendfluttercoach/model/user.dart';

part 'destination.g.dart';

@RestApi()
abstract class DestinationService {
  factory DestinationService(Dio dio, {String baseUrl}) = _DestinationService;

  @GET("/destination")
  Future<List<Destination>> getDestinations();

}

